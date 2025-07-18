# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "swy-terraform-state-files"
    key     = "jupiter-website-ecs.tfstate"
    region  = "us-east-1"
    profile = "terraform-user"
  }
}