terraform {
  backend "s3"  {
    encrypt = "true"
    bucket = "repoadsbx2"
    dynamodb_table = "iac-nubiral-terraform-tfstate"
    region = "us-east-1"
    key = "lnx/lnxservice.tfstate"
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }
  required_providers {
    awx = {
      source = "nolte/awx"
      version = "0.2.2"
    }
  }  
}


