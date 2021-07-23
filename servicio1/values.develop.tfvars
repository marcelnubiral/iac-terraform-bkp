awx_inventory_name = "ArcosLP"
awx_inventory_group_name = "lnxCentos"
awx_organization_name = "Default"
awx_template_id = 13
#awx_group_id = 12
awx_user = "jenkins2" #usuario jenkins en AWX
awx_pass = "jenkins2" #password jenkins en AWX
awx_host = "https://172.21.1.149:8043/" 
#
aws_region     = "us-east-1"
aws_account_id = "884913712919"
aws_role_name  = "IAM-ROL-IAC-JNK"
#
ec2_ami = "ami-08acb886b9c95f1e5" #CIS Oracle Linux 8
ec2_instance_type = "t2.micro"
ec2_subnet_id = "subnet-0b53a6ae43e71d4b3"
ec2_key_name = "key_arcos_sandbox"
ec2_security_groups = ["sg-0ead77c0f02120937"]
ec2_public_ip = false
ec2_base_name = "webserver-"
ec2_instance_count = 2
ec2_root_volume_size = 30
ec2_root_volume_type = "gp2"

ebs_block_device = [
{
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = 5
    encrypted   = false
    delete_on_termination = false
    #kms_key_id  = aws_kms_key.this.arn
},
{
    device_name = "/dev/sdc"
    volume_type = "gp2"
    volume_size = 5
    encrypted   = false
    #kms_key_id  = aws_kms_key.this.arn
}
]

#TAGS
aws_so  = "LNX"
aws_n   = "01" 
aws_env = "DEV"


