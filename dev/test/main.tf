
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::884913712919:role/IAM-ROL-IAC-JNK"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  //ami = "" // NO ES ELEGANTE!
  instance_type = "t2.micro"
  key_name = "key_arcos_sandbox3"

  tags = {
    Name = "web-server"
  }
}


