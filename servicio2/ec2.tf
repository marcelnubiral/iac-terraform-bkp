provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn  = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }  
}

provider "awx" {
  hostname = var.awx_host
  insecure = var.awx_insecure
  username = var.awx_user
  password = var.awx_pass
}

data "awx_organization" "default" {
  name = var.awx_organization_name
}

data "awx_inventory" "default" {
  name = var.awx_inventory_name
}

resource "awx_inventory_group" "default" {
    name            = var.awx_inventory_group_name
    inventory_id    = data.awx_inventory.default.id
    variables       = <<YAML
    ---
    ansible_user: 'ansible'
    ansible_password: 'QChqTV4d3cbsG~~::E66#N'
    ansible_connection: 'winrm'
    ansible_winrm_server_cert_validation: 'ignore'
    ansible_winrm_transport: 'basic'
    ansible_winrm_scheme: 'https'
YAML
}

locals {
  instances_count = 1
}

data "aws_iam_instance_profile" "s3-access-role" {
 name = "AmazonSSMRoleForInstancesQuickSetup"
}

data "aws_ami" "windows"{
  owners = ["679593333241"]
  most_recent = true
  filter {
    name = "name"
    values = ["CIS Microsoft Windows Server 2019 Benchmark v* - Level 1-*"]
   }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "srv" {
  count                       = local.instances_count
  ami                         = "${data.aws_ami.windows.id}"
  key_name                    = var.ec2_key_name
  iam_instance_profile        = data.aws_iam_instance_profile.s3-access-role.name
  vpc_security_group_ids      = var.ec2_security_groups
  associate_public_ip_address = true
  source_dest_check           = false
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.ec2_subnet_id
  user_data                   = <<EOF
    <powershell>
    net user ${var.INSTANCE_USERNAME} '${var.INSTANCE_PASSWORD}' /add /y
    net localgroup administrators ${var.INSTANCE_USERNAME} /add
    Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" -Name AllowBasic -Value 1
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
    $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
    (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
    powershell.exe -ExecutionPolicy ByPass -File $file -forcenewsslcert
    </powershell>
    EOF
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.ec2_root_kms_id
    volume_size           = var.ec2_root_volume_size
    volume_type           = var.ec2_root_volume_type
  }
  tags = {
    Name                      = "NUB-${var.aws_so}${count.index}${var.aws_n}-${var.aws_env}"
    productname               = "iac-nubiral"
    environment               = var.aws_env
    shutdownschedule          = "8a20"
    productowneremail         = "Gonzalo.Aresrivas@ar.mcd.com"
  }
}

resource "awx_host" "axwnode" {
  count = local.instances_count
  name         = "NUB-${var.aws_so}${count.index}${var.aws_n}-${var.aws_env}"
  description  = "Nodo agregado desde terraform"
  inventory_id = data.awx_inventory.default.id
  group_ids = [ 
    awx_inventory_group.default.id
  ]
  enabled   = true
  variables = "ansible_host: ${element(aws_instance.srv.*.private_ip, count.index)}"
}
#