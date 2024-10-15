variable "nops_url" {
  type        = string
  default     = "https://app.nops.io/"
  description = "The nOps base URL"
}

variable "nops_principal" {
  type        = string
  default     = "202279780353"
  description = "The nOps principal account number"
}

variable "api_key" {
  type        = string
  description = "The nOps API key"
}

variable "system_bucket_name" {
  type        = string
  description = "The name of the system bucket for nOps integration"
}

variable "reconfigure" {
  type        = bool
  default     = false
  description = "If true, allows overriding existing project settings. If false, stops execution if project already exists."
}
