# Contributing
This document contains all details required to contribute into this repository, please review before making changes on this module.

## Prerequisites
- Terraform CLI
- [pre-commit](https://pre-commit.com/)
- Access to a test `nOps` account

## Installation of required checks
We use `pre-commit`  to run standard Terraform validations and linting, to set these up install
the tool. Once installed run `pre-commit install` in a terminal at the root of the repository.
You should see an output similar to:
```yaml
pre-commit installed at .git/hooks/pre-commit
```
From now on the Terraforms checks defined in the `pre-commit` configuration file will be ran
whenever you commit changes.

In order to manually run these checks execute `pre-commit run -a`.

## How to test changes locally
1. Clone this repository and make changes to the module
2. Create a file called `terraform.auto.tfvars` on the root of this repository
3. Add the required variables
    ```yaml
    api_key     = "xxxx.xxxxxxxx"
    ```
4. Test deployment

## How to test remote changes
1. Create a standard terraform configuration directory locally
2. Change the source parameter to the following, and add the required variables
```hcl
provider "aws" {
  alias  = "root"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/admin-role"
  }
}

module tf_onboarding {
  providers = {
    aws = aws.root
  }
  source             = "github.com/nops-io/terraform-aws-nops-integration.git?ref=remote_branch"
  api_key            = "nops_api_key"
}
```
3. To clone over SSH use the following base url: `git@github.com:nops-io/terraform-aws-nops-integration.git`
4. Change `remote_branch` to the target branch you want to test
5. Test deployment

# How to submit changes
Once you're happy with your changes, commit them and open a pull request.
Make sure to run `pre-commit` before opening the request.
