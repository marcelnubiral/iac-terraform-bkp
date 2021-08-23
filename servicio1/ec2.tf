provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
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
  name         = var.awx_inventory_group_name
  inventory_id = data.awx_inventory.default.id
}

locals {
  instances_count = 1
}

resource "aws_instance" "srv" {
  count                       = local.instances_count
  ami                         = var.ec2_ami
  key_name                    = var.ec2_key_name
  #iam_instance_profile        = aws_iam_instance_profile.ec2-access-profile.name
  vpc_security_group_ids      = var.ec2_security_groups
  associate_public_ip_address = true
  source_dest_check           = false
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.ec2_subnet_id
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
  count        = local.instances_count
  name         = "NUB-${var.aws_so}${count.index}${var.aws_n}-${var.aws_env}"
  description  = "Nodo agregado desde terraform"
  inventory_id = data.awx_inventory.default.id
  group_ids    = [
    awx_inventory_group.default.id
  ]
  enabled      = true
  variables    = "ansible_host: ${element(aws_instance.srv.*.private_ip, count.index)}"
}





# data "aws_iam_role" "s3-access-role" {
#   name = "AmazonSSMRoleForInstancesQuickSetup"
# }


# resource "aws_iam_instance_profile" "ec2-access-profile" {
#   name = "ec2_access_profile"
#   role = data.aws_iam_role.s3-access-role.name
# }

#role para S3 AmazonSSMRoleForInstancesQuickSetup

