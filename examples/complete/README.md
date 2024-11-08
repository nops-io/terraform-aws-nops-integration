# Complete onboarding example with 1 payer account and 2 child accounts



## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |
| <a name="requirement_nops"></a> [nops](#requirement\_nops) | ~>0.0.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.7 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_onboarding_child_account"></a> [onboarding\_child\_account](#module\_onboarding\_child\_account) | ../../ | n/a |
| <a name="module_onboarding_child_account_2"></a> [onboarding\_child\_account\_2](#module\_onboarding\_child\_account\_2) | ../../ | n/a |
| <a name="module_onboarding_payer_account"></a> [onboarding\_payer\_account](#module\_onboarding\_payer\_account) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
