provider "aws" {
  region = "us-east-1"
  // assume_role {
  //   role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }

resource "aws_instance" "web" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
#


