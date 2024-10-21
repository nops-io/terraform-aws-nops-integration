variable "nops_url" {
  type        = string
  default     = "https://app.nops.io/"
  description = "The nOps base URL"
}

variable "api_key" {
  type        = string
  description = "The nOps API key"
}

variable "reconfigure" {
  type        = bool
  default     = false
  description = "If true, allows overriding existing project settings. If false, stops execution if project already exists."
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
