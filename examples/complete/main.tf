locals {
  region = "us-east-1"
}

provider "aws" {
  alias  = "root"
  region = local.region
  # Assume role in payer account
  assume_role {
    role_arn = "arn:aws:iam::123456789123:role/admin-role"
  }
}


module "onboarding_payer_account" {
  providers = {
    aws = aws.root
  }
  source             = "../../"
  api_key            = "xxxxx-xxx"
  system_bucket_name = "custom_bucket_name"
  # reconfigure will trigger an update if a project exists, this is to avoid updating unwanted projects.
  reconfigure = true
}

provider "aws" {
  alias  = "child_1"
  region = local.region
  # Assume role in child_1 account
  assume_role {
    role_arn = "arn:aws:iam::123456789123:role/admin-role"
  }
}

module "onboarding_child_account" {
  providers = {
    aws = aws.child_1
  }
  source             = "../../"
  api_key            = "xxxxx-xxx"
  system_bucket_name = "custom_bucket_name"
  # Required after the first run to update the created project
  reconfigure = true
}

provider "aws" {
  alias  = "child_2"
  region = local.region
  # Assume role in child account
  assume_role {
    role_arn = "arn:aws:iam::123456789123:role/admin-role"
  }
}
