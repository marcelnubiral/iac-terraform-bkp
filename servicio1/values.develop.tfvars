awx_inventory_name = "ArcosLP"
awx_inventory_group_name = "lnxCentos"
awx_organization_name = "Default"
awx_template_id = 13
#awx_group_id = 12
awx_user = "jenkins2"
awx_pass = "jenkins2"
awx_host = "http://xxxxxxxxxxxx"
#
aws_region     = "us-east-1"
aws_account_id = "2xxxxxxxxxx"
aws_role_name  = "jenkins_arcos_role"
#
ec2_ami = "ami-0be2609ba883822ec"
ec2_instance_type = "t2.micro"
ec2_subnet_id = "subnet-xxxxxxxxxxx"
ec2_key_name = "naas-xxxxxxxx"
ec2_security_groups = ["sg-xxxxxxxxxxxx"]
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


