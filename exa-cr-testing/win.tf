// provider "aws" {
//   region = "us-east-1"
//   assume_role {
//     role_arn  = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
//   }  
// }

provider "awx" {
  hostname = var.awx_host
  insecure = var.awx_insecure
  username = var.awx_user
  password = var.awx_pwd
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
    ansible_user: '${var.ansible_win_user}'
    ansible_password: '${var.ansible_win_pwd}'
    ansible_connection: 'winrm'
    ansible_winrm_server_cert_validation: 'ignore'
    ansible_winrm_transport: 'basic'
    ansible_winrm_scheme: 'https'
YAML
}

locals {
  #instances_count = 1
  instances_win = flatten(local.serverconfig_win)
}
locals {
  serverconfig_win = [
    for srv in var.configuration_win : [
      for i in range(1, srv.no_of_instances+1) : {
        instance_name = "${srv.application_name}-${i}"
        instance_type = srv.instance_type
        subnet_id   = srv.subnet_id
        #ami = srv.ami
        security_groups = srv.security_groups
        #volume_size = srv.volume_size
      }
    ]
  ]
}

// data "aws_iam_instance_profile" "s3-access-role" {
//  name = "AmazonSSMRoleForInstancesQuickSetup"
// }

data "aws_ami" "windows"{
  owners = ["884913712919"]
  most_recent = true
  filter {
    name = "name"
    values = ["Arcos-Win-AMI-*"]
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

resource "aws_instance" "srv_win" {
  for_each = {for server in local.instances: server.instance_name =>  server}

  #count                       = local.instances_count
  ami                         = "${data.aws_ami.windows.id}"
  #ami                         = each.value.ami
  key_name                    = var.ec2_key_name
  #iam_instance_profile        = data.aws_iam_instance_profile.s3-access-role.name
  security_groups             = each.value.security_groups
  associate_public_ip_address = false
  source_dest_check           = false
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  user_data = <<EOF
  <powershell>
    $pw = "${var.domain_pwd}" | ConvertTo-SecureString -asPlainText -Force 
    $usr = "${var.domain_user}" 
    $creds = New-Object System.Management.Automation.PSCredential($usr,$pw)
    Add-Computer -DomainName aws.local -Credential $creds -restart -force -verbose
  </powershell>
  EOF
  root_block_device {
    #device_name           = "/dev/sda1"
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.ec2_root_kms_id
    volume_size           = var.ec2_root_volume_size_win[0]
    volume_type           = var.ec2_root_volume_type
  }
  ebs_block_device {
    device_name           = "/dev/sda2"
    delete_on_termination = true
    kms_key_id            = var.ec2_root_kms_id
    encrypted             = true
    volume_size           = var.ec2_root_volume_size_win[1]
    volume_type           = var.ec2_root_volume_type
    
  }

  tags = {
    Name                      = "exa-cr-${var.aws_env}-${var.aws_so_win}-02"
    productname               = "iac-nubiral"
    environment               = var.aws_env
    shutdownschedule          = "8a20"
    productowneremail         = "Gonzalo.Aresrivas@ar.mcd.com"
  }
}

resource "awx_host" "axwnode" {
  #count = local.instances_count
  name         = "bi-uy-${var.aws_env}-${var.aws_so_win}"
  description  = "Nodo agregado desde terraform"
  inventory_id = data.awx_inventory.default.id
  group_ids = [ 
    awx_inventory_group.default.id
  ]
  enabled   = true
  #variables = "ansible_host: ${element(aws_instance.srv.*.private_ip, count.index)}"
}#