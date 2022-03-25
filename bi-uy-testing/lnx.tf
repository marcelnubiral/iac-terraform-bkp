provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }
}

// provider "awx" {
//   hostname = var.awx_host
//   insecure = var.awx_insecure
//   username = var.awx_user
//   password = var.awx_pwd
// }

// data "awx_organization" "default" {
//   name = var.awx_organization_name
// }

// data "awx_inventory" "default" {
//   name = var.awx_inventory_name
// }


locals {
  #instances_count = 1
  instances = flatten(local.serverconfig)
}

locals {
  serverconfig = [
    for srv in var.configuration : [
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

data "aws_ami" "oracle"{
  owners = ["884913712919"]
  most_recent = true
  filter {
    name = "name"
    values = ["Arcos-Oracle-AMI-*"]  
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

resource "aws_instance" "srv_lnx" {
  
  for_each = {for server in local.instances: server.instance_name =>  server}
  
  #count                       = local.instances_count
  ami                         = "${data.aws_ami.oracle.id}"
  #ami                         = each.value.ami
  key_name                    = var.ec2_key_name
  #iam_instance_profile        = data.aws_iam_instance_profile.s3-access-role.name
  security_groups              = each.value.security_groups
  associate_public_ip_address = false
  source_dest_check           = true
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  #volume_size                 = each.volume_size
  user_data                   = filebase64("${path.module}/user_data/userdata.sh")
  #user_data = <<EOF
  #  echo ${var.domain_pwd} | realm join -U ${var.domain_user} aws.local
  #EOF
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.ec2_root_kms_id
    volume_size           = var.ec2_root_volume_size[0]
    volume_type           = var.ec2_root_volume_type
  }
  ebs_block_device {
    device_name           = "/dev/sda2"
    delete_on_termination = true
    kms_key_id            = var.ec2_root_kms_id
    encrypted             = true
    volume_size           = var.ec2_root_volume_size[1]
    volume_type           = var.ec2_root_volume_type
    
  }
  tags = {
    Name                      = "bi-uy-${var.aws_env}-${var.aws_so}"
    productname               = "iac-nubiral"
    environment               = var.aws_env
    shutdownschedule          = "8a20"
    productowneremail         = "Gonzalo.Aresrivas@ar.mcd.com"
  }
}
