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

- Terraform v0.13+
- AWS CLI configured with appropriate permissions
- nOps API key

## Usage

1. Clone this repository:


2. Create a `terraform.tfvars` file with your specific variables:
```hcl
aws_region = "us-west-2"
api_key    = "your-nops-api-key"
system_bucket_id = "your-system-bucket-id"
```

3. Initialize Terraform:

```
terraform init
```

Plan and apply the Terraform configuration:

```
terraform apply
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
