variable awx_user {}
variable awx_pwd {}
variable awx_host {}
variable awx_insecure {}
variable awx_template_id {}
variable awx_inventory_name {}
variable awx_inventory_group_name {}
variable awx_organization_name{}

#variable aws_region {}
variable aws_account_id {}
variable aws_role_name {}


variable ec2_instance_type {}

variable ec2_subnet_id {}
variable ec2_key_name {}
variable ec2_security_groups { type = list }
variable ec2_public_ip {}
variable ec2_base_name {}

variable ec2_root_volume_size {}
variable ec2_root_volume_type {}
variable ec2_root_volume_size_ebs {}
variable ec2_root_kms_id {}

variable ansible_win_user {
    sensitive = true
}
variable ansible_win_pwd {
    sensitive = true
}

variable domain_user {
    sensitive = true
}

variable domain_pwd {
    sensitive = true
} 

# TAGS
variable aws_so {}
variable aws_n {}
variable aws_env {}

variable "aws_region" {
  description = "AWS region where the resources will be created"

  type = object({
    dev  = string
    prod = string
  })

  default = {
    dev  = "us-east-1"
    prod = "us-east-2"
  }
}
