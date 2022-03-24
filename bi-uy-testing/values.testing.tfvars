#AWX
awx_inventory_name = "Arcos"
awx_inventory_group_name = "lnxCentos"
awx_organization_name = "Default"
awx_template_id = 9
awx_host = "https://172.21.1.149:8043" 
awx_insecure = "true"

aws_region     = "us-east-1"
aws_account_id = "884913712919"
aws_role_name  = "IAM-ROL-IAC-JNK"

#ec2_instance_type = "t3.small"
#ec2_subnet_id = "subnet-0b53a6ae43e71d4b3"
ec2_key_name = "key_arcos_sandbox"
#ec2_security_groups = ["sg-07a89f708579b7195"]
ec2_public_ip = false
ec2_base_name = "webserver-"
#ec2_root_volume_size = 40
ec2_root_volume_type = "gp3"
ec2_root_kms_id = "e69c23d6-8e7d-4629-a3b1-1103cb5e8b4f"

#TAGS
aws_so  = "lnx"
aws_so_win  = "win"
aws_n   = "001" 
aws_env = "dev"
aws_pais = "uy"
aws_servicio = "bi"

#DISCOS
ec2_root_volume_size = ["33","32"]
ec2_root_volume_size_win = ["30","30"]

# INSTANCIAS LNX WIN
configuration = [
  // {
  //   "application_name" : "develop",
  // // "ami" : "ami-089582bef738dbf6a",
  //   "instance_type" : "t2.medium",
  //   "no_of_instances" : "1",
  //   "subnet_id" : "subnet-0b53a6ae43e71d4b3",
  //   // "volume_size : ["21","21"],
  //   "security_groups" : ["sg-07a89f708579b7195"]
  // }
  {
    "application_name" : "testing",
    "ami" : "ami-089582bef738dbf6a",
    "instance_type" : "t3.micro",
    "no_of_instances" : "1",
    "subnet_id" : "subnet-0b53a6ae43e71d4b3",
    "security_groups" : ["sg-07a89f708579b7195"]
  }
  // {
  //   "application_name" : "master",
  //   "ami" : "ami-089582bef738dbf6a",
  //   "instance_type" : "t3.micro",
  //   "no_of_instances" : "1",
  //   "subnet_id" : "subnet-0b53a6ae43e71d4b3",
  //   "security_groups" : ["sg-07a89f708579b7195"]
  // }
  
]

configuration_win = [
  // {
  //   "application_name" : "develop",
  // // "ami" : "ami-089582bef738dbf6a",
  //   "instance_type" : "t2.medium",
  //   "no_of_instances" : "1",
  //   "subnet_id" : "subnet-0b53a6ae43e71d4b3",
  //   // "volume_size : ["21","21"],
  //   "security_groups" : ["sg-07a89f708579b7195"]
  // }
  {
    "application_name" : "testing",
    "ami" : "ami-089582bef738dbf6a",
    "instance_type" : "t3.micro",
    "no_of_instances" : "0",
    "subnet_id" : "subnet-0b53a6ae43e71d4b3",
    "security_groups" : ["sg-07a89f708579b7195"]
  }
  // {
  //   "application_name" : "master",
  //   "ami" : "ami-089582bef738dbf6a",
  //   "instance_type" : "t3.micro",
  //   "no_of_instances" : "1",
  //   "subnet_id" : "subnet-0b53a6ae43e71d4b3",
  //   "security_groups" : ["sg-07a89f708579b7195"]
  // }
  
]