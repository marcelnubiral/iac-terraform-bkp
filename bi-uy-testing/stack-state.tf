terraform {
  backend "s3"  {
    encrypt = "true"
    bucket = "repoadsbx2"
    dynamodb_table = "iac-nubiral-terraform-tfstate"
    region = "us-east-1"
    key = "lnx/lnxservice.tfstate"
    role_arn = "arn:aws:iam::884913712919:role/IAM-ROL-IAC-JNK"
  }
  // required_providers {
  //   awx = {
  //     source = "terraform.arcos/local/awx"
  //     version = "0.2.3"
  //   }
  // }  
}


