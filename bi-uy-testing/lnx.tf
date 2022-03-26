provider "aws" {
  region = "us-east-1"
  // assume_role {
  //   role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }

resource "aws_instance" "web" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  security_groups = "sg-07a89f708579b7195"
  subnet_id  = "subnet-0b53a6ae43e71d4b3"

  tags = {
    Name = "HelloWorld"
  }
}
#


