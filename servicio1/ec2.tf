provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }
}
provider "awx" {
  hostname = var.awx_host
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
  vpc_security_group_ids      = var.ec2_security_groups
  associate_public_ip_address = true
  source_dest_check           = false
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.ec2_subnet_id
  tags = {
    Name  = "poc-arcos-lnx",
    Owner = "xxxx"
  }
}

resource "awx_host" "axwnode" {
  count        = local.instances_count
  name         = "poc-arcos-demo-lnx${count.index}"
  description  = "Nodo agregado desde terraform"
  inventory_id = data.awx_inventory.default.id
  group_ids = [
    awx_inventory_group.default.id
  ]
  enabled   = true
  variables = "ansible_host: ${element(aws_instance.srv.*.private_ip, count.index)}"
}
