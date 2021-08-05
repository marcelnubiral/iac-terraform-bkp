terraform {
  backend "s3"  {
    encrypt = "true"
    bucket = "repoadsbx2"
    dynamodb_table = "iac-nubiral-terraform-tfstate"
    region = "us-east-1"
    key = "windows/winservice.tfstate"
  }
  required_providers {
    awx = {
      source = "nolte/awx"
      version = "0.2.2"
    }
  }  
}


