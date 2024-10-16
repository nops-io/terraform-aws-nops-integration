# nOps AWS Integration Terraform Module

## Description

This Terraform module automates the process of integrating your AWS account with nOps, a cloud management and optimization platform. It streamlines the setup of necessary AWS resources and permissions, enhancing the onboarding experience for nOps users.

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

  source             = "nops-io/nops-integration/aws"
  # This bucket will be created by the module with the name provided here, make sure its globally unique.
  system_bucket_name = "example"
  # nOps API key that will be used to authenticate with the nOps platform to onboard the account.
  api_key            = "nops_api_key"
}
```

2. Initialize Terraform:

```
terraform init
```

3. Plan and apply the Terraform configuration:

```
terraform apply
```

If you want to reconfigure an existing nOps account:

```
terraform apply -var="reconfigure=true"
```

or

```hcl
module tf_onboarding {
  providers = {
    aws = aws.root
  }

  source             = "nops-io/nops-integration/aws"
  system_bucket_name = "example"
  api_key            = "nops_api_key"
  reconfigure        = true
}
```

4. Troubleshooting

If you want to reinstall the stack you might got problem like

```
│ Error: creating IAM Role (NopsIntegrationRole-xxxxx): EntityAlreadyExists: Role with name NopsIntegrationRole-xxxxx already exists.
```

You can import the role to terraform state by running the following command
```
terraform import aws_iam_role.nops_integration_role NopsIntegrationRole-xxxxx
```
### Onboarding child account

Onboarding child accounts is performed using the same module, it already contains the logic to react when its being applied on any account that is not root
```hcl
provider "aws" {
  alias  = "child"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::xxxxxxxx:role/admin-role"
  }
}

module tf_onboarding {
  providers = {
    aws = aws.child
  }

  source             = "nops-io/nops-integration/aws"
  # This bucket will be created by the module with the name provided here, make sure its globally unique.
  system_bucket_name = "example"
  # nOps API key that will be used to authenticate with the nOps platform to onboard the account.
  api_key            = "nops_api_key"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.nops_integration_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.nops_eventbridge_integration_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_integration_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.nops_system_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.nops_system_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.nops_bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [null_resource.check_api_errors](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.check_existing_project](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.force_new_role](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.project_check](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.reconfigure_trigger](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [time_sleep.wait_for_iam_role](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [http_http.check_current_client](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.check_project_aws](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.create_nops_project](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.notify_nops_integration_complete](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | The nOps API key | `string` | n/a | yes |
| <a name="input_nops_principal"></a> [nops\_principal](#input\_nops\_principal) | The nOps principal account number | `string` | `"202279780353"` | no |
| <a name="input_nops_url"></a> [nops\_url](#input\_nops\_url) | The nOps base URL | `string` | `"https://app.nops.io/"` | no |
| <a name="input_reconfigure"></a> [reconfigure](#input\_reconfigure) | If true, allows overriding existing project settings. If false, stops execution if project already exists. | `bool` | `false` | no |
| <a name="input_system_bucket_name"></a> [system\_bucket\_name](#input\_system\_bucket\_name) | The name of the system bucket for nOps integration | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_current_client_id"></a> [current\_client\_id](#output\_current\_client\_id) | The client ID of the current account in nOps |
| <a name="output_is_master_account"></a> [is\_master\_account](#output\_is\_master\_account) | Whether the current account is the master account |
| <a name="output_is_master_account_out"></a> [is\_master\_account\_out](#output\_is\_master\_account\_out) | Indicates if the account is the master account |
| <a name="output_master_account_id"></a> [master\_account\_id](#output\_master\_account\_id) | The account ID of the AWS Organization's master account |
| <a name="output_nops_integration_status"></a> [nops\_integration\_status](#output\_nops\_integration\_status) | Indicates if the nOps integration notification was sent |
| <a name="output_notify_nops_integration_complete_status"></a> [notify\_nops\_integration\_complete\_status](#output\_notify\_nops\_integration\_complete\_status) | Status of the nOps integration notification |
| <a name="output_project_aws_list"></a> [project\_aws\_list](#output\_project\_aws\_list) | List of projects in nOps |
| <a name="output_project_status"></a> [project\_status](#output\_project\_status) | Status of the nOps project for this account |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_system_bucket_name"></a> [system\_bucket\_name](#output\_system\_bucket\_name) | The name of the S3 bucket (if created) |
<!-- END_TF_DOCS -->
