# nOps AWS Integration Terraform Module

## Description

This Terraform module automates the process of integrating your AWS account with nOps, a cloud management and optimization platform. It streamlines the setup of necessary AWS resources and permissions, enhancing the onboarding experience for nOps users.

![](./assets/Terraform.png)

## Features

- Automatic detection of existing nOps projects for the AWS account
- Creation of new nOps projects if none exist
- Handling of master and member AWS accounts
- Automatic setup of IAM roles and policies for nOps integration
- S3 bucket creation and configuration for master accounts
- Integration with nOps API for secure token exchange

## Prerequisites

- Terraform v1.0+
- AWS CLI configured with appropriate permissions
- nOps API key

## Usage

### Onboarding Payer account

The below example shows how to add the management (root) AWS account integration:


1. Being authenticated on the Payer account of the AWS organization, add the following code:
```hcl
terraform {
  required_providers {
    nops = {
      source = "nops-io/nops"
    }
  }
}

provider "nops" {
  # nOps API key that will be used to authenticate with the nOps platform to onboard the account.
  # It's recommended to not commit this value into VCS, to securely provide this value use a tfvars that isn't commited into any repository.
  # This value can also be provided as an environment variable NOPS_API_KEY
  nops_api_key            = "XXXXXXX"
}

provider "aws" {
  alias  = "root"
}

module tf_onboarding {
  providers = {
    aws = aws.root
  }
  source             = "nops-io/nops-integration/aws"
  # nOps API key that will be used to authenticate with the nOps platform to onboard the account.
}
```

2. Initialize Terraform:

```
terraform init
```

3. Plan and apply the Terraform configuration:

```
terraform plan -out=plan

terraform apply plan
```


### Onboarding child account

Onboarding child accounts is performed using the same module, it already contains the logic to react when its being applied on any account that is not root
```hcl
terraform {
  required_providers {
    nops = {
      source = "nops-io/nops"
    }
  }
}

provider "nops" {
  # nOps API key that will be used to authenticate with the nOps platform to onboard the account.
  # It's recommended to not commit this value into VCS, to securely provide this value use a tfvars that isn't commited into any repository.
  # This value can also be provided as an environment variable NOPS_API_KEY
  nops_api_key            = "XXXXXXX"
}

provider "aws" {
  alias  = "child"
  region = "us-east-1"
}

module tf_onboarding {
  providers = {
    aws = aws.child
  }
  source             = "nops-io/nops-integration/aws"
}
```
## Importing existing nOps projects ##

The **nOps** Terraform provider supports importing existing projects into the state as to allow already onboarded customers to manage their projects with IaC. In order to import a project follow the
next steps:

- First, grab the project ID from **nOps**. You can get it from the AWS accounts [dashboard](https://app.nops.io/v3/settings?tab=AWS%20Accounts), each account has an ID below its name.
- Then in your Terraform configuration run the following commands:
```
terraform import module.tf_onboarding.nops_project.project XXXXX
```
You should see the following output
```
module.tf_onboarding.nops_project.project: Importing from ID "XXXX"...
module.tf_onboarding.nops_project.project: Import prepared!
  Prepared nops_project for import
module.tf_onboarding.nops_project.project: Refreshing state...

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

```
- After the above, we need to import the integration with the AWS account, for this run the following replacing your AWS account ID.
```
terraform import module.tf_onboarding.nops_integration.integration XXXXXX
```
You should see the following output, with the AWS account ID being imported into the state.
```
module.tf_onboarding.nops_integration.integration: Importing from ID "XXXXXX"...
module.tf_onboarding.nops_integration.integration: Import prepared!
  Prepared nops_integration for import
module.tf_onboarding.nops_integration.integration: Refreshing state...

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```


## Minimum nOps required IAM policies ##

A variable named `min_required_permissions` has been declared in the **nOps** terraform module that enables customers choosing a more restricted setup to be able to use the platform.
In order to enter this restricted mode, set the variable to `true`. Take into consideration that **nOps** will not be able to get the full metadata for AWS resources with this setup.
To review these permissions, refer to the [policies](../IAM/iam-minimum-platform-permissions.mdx) page or the [Terraform module](https://registry.terraform.io/modules/nops-io/nops-integration/aws/latest) for the most recent updates.

## Troubleshooting ##

If you see an error like the following
```
Error: Error getting remote project data

  with module.tf_onboarding.data.nops_projects.current,
  on .terraform/modules/tf_onboarding/data.tf line 9, in data "nops_projects" "current":
  9: data "nops_projects" "current" {}

```
Check that the API key value being provided is valid and exists in your account. Your current API keys are listed [here](https://app.nops.io/v3/settings?tab=API%20Key).

**nOps** supports onboarding unique AWS accounts per Client, onboarding the same AWS account multiple times for one Client isn't allowed. So if you see an error like the following
```
Error: Error: a project already exists for this AWS account "XXXXXX" with ID YYYY, please review or import.

  with module.tf_onboarding_should_fail.nops_project.project,
  on .terraform/modules/tf_onboarding_should_fail/main.tf line 1, in resource "nops_project" "project":
   1: resource "nops_project" "project" {}

Project found for AWS account "XXXX"
```
Then check that the credentials being used to deployed are correct. If they are, we support importing projects into the Terraform state. Please refer to the [import section.](#importing-existing-nops-projects)



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |
| <a name="requirement_nops"></a> [nops](#requirement\_nops) | >= 0.0.6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_nops"></a> [nops](#provider\_nops) | >= 0.0.6 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.nops_integration_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.nops_compute_copilot_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_essentials_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_integration_minimum_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_integration_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_system_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_wafr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.nops_integration_readonly_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.nops_system_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.nops_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.nops_bucket_block_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.nops_bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [nops_integration.integration](https://registry.terraform.io/providers/nops-io/nops/latest/docs/resources/integration) | resource |
| [nops_project.project](https://registry.terraform.io/providers/nops-io/nops/latest/docs/resources/project) | resource |
| [time_sleep.wait_for_resources](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.iam_readonly_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [nops_projects.current](https://registry.terraform.io/providers/nops-io/nops/latest/docs/data-sources/projects) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | [DEPRECATED] The nOps API key, can be supplied as an env var NOPS\_API\_KEY or in the provider call in your configuration. | `string` | `""` | no |
| <a name="input_cloud_account_name"></a> [cloud\_account\_name](#input\_cloud\_account\_name) | Name with which the AWS account will appear on the nOps platform, leave empty for a name with format: AWS Account XXXXXX. | `string` | `""` | no |
| <a name="input_min_required_permissions"></a> [min\_required\_permissions](#input\_min\_required\_permissions) | If true, IAM policies with the min base permissions for nOps to get cost and usage data will be created. Some platform features will not be available. | `bool` | `false` | no |
| <a name="input_reconfigure"></a> [reconfigure](#input\_reconfigure) | [DEPRECATED] If true, allows overriding existing project settings. If false, stops execution if project already exists. | `bool` | `false` | no |
| <a name="input_system_bucket_name"></a> [system\_bucket\_name](#input\_system\_bucket\_name) | [DEPRECATED]  The name of the system bucket for nOps integration. | `string` | `"na"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_current_client_id"></a> [current\_client\_id](#output\_current\_client\_id) | The client ID of the current account in nOps |
| <a name="output_is_master_account"></a> [is\_master\_account](#output\_is\_master\_account) | Whether the current account is the master account |
| <a name="output_master_account_id"></a> [master\_account\_id](#output\_master\_account\_id) | The account ID of the AWS Organization's master account |
| <a name="output_project_aws_list"></a> [project\_aws\_list](#output\_project\_aws\_list) | List of projects in nOps |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_system_bucket_name"></a> [system\_bucket\_name](#output\_system\_bucket\_name) | The name of the S3 bucket (if created) |
<!-- END_TF_DOCS -->
