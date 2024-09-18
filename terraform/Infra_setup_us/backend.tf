terraform {
  backend "s3" {
    bucket          = "backends3"
    key               = "infra_config/terraform.tfstate"
    region           = "eu-west-2"

  }
}