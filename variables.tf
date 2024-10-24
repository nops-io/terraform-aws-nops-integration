variable "api_key" {
  type        = string
  description = "The nOps API key"
  sensitive   = true
}

variable "essentials" {
  type        = bool
  default     = true
  description = "If true, the IAM policy required for nOps essentials will be created."
}

variable "compute_copilot" {
  type        = bool
  default     = true
  description = "If true, the IAM policy required for nOps compute copilot will be created."
}

variable "wafr" {
  type        = bool
  default     = true
  description = "If true, the IAM policy required for nOps WAFR will be created."
}

# tflint-ignore: terraform_unused_declarations
variable "reconfigure" {
  type        = bool
  default     = false
  description = "[DEPRECATED] If true, allows overriding existing project settings. If false, stops execution if project already exists."
}
