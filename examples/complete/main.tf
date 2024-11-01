locals {
  region = "us-east-1"
}

provider "nops" {}

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
  source = "../../"
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
  source = "../../"
}

provider "aws" {
  alias  = "child_2"
  region = local.region
  # Assume role in child account
  assume_role {
    role_arn = "arn:aws:iam::123456789123:role/admin-role"
  }
}

module "onboarding_child_account_2" {
  providers = {
    aws = aws.child_2
  }
  source = "../../"
}
