# tflint-ignore: terraform_unused_declarations
variable "api_key" {
  type        = string
  description = "[DEPRECATED] The nOps API key, can be supplied as an env var NOPS_API_KEY or in the provider call in your configuration."
  sensitive   = true
  default     = ""
}

variable "min_required_permissions" {
  type        = bool
  default     = false
  description = "If true, IAM policies with the min base permissions for nOps to get cost and usage data will be created. Some platform features will not be available."
}

# tflint-ignore: terraform_unused_declarations
variable "system_bucket_name" {
  type        = string
  default     = "na"
  description = "[DEPRECATED]  The name of the system bucket for nOps integration."
}

# tflint-ignore: terraform_unused_declarations
variable "reconfigure" {
  type        = bool
  default     = false
  description = "[DEPRECATED] If true, allows overriding existing project settings. If false, stops execution if project already exists."
}

variable "cloud_account_name" {
  type        = string
  default     = ""
  description = "If true, IAM policies with the min base permissions for nOps to get cost and usage data will be created. Some platform features will not be available."
}
