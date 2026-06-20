variable "name" {
  type        = string
  description = "WAF name"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name)) && length(var.name) >= 1 && length(var.name) <= 128
    error_message = "WAF name must be 1-128 characters and contain only letters, numbers, underscores, and hyphens."
  }
}

variable "scope" {
  type        = string
  description = "WAF scope (REGIONAL or CLOUDFRONT)"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "default_action" {
  type        = string
  description = "Default action"
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Default action must be either allow or block."
  }
}

variable "rules" {
  type        = list(any)
  description = "WAF managed rule definitions"
  default     = []
}

variable "visibility_config" {
  type        = any
  description = "Web ACL visibility config overrides"
  default     = {}
}

variable "enable_logging" {
  type        = bool
  description = "Enable WAF logging to CloudWatch Logs"
  default     = false
}

variable "log_retention_in_days" {
  type        = number
  description = "Retention period in days for WAF log group"
  default     = 90
}

variable "log_kms_key_id" {
  type        = string
  description = "KMS key ID for the WAF log group"
  default     = ""
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "Enable sampled request visibility"
  default     = true
}

variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "Enable CloudWatch metrics visibility"
  default     = true
}

variable "custom_response_bodies" {
  type        = any
  description = "Custom response body definitions"
  default     = {}
}

variable "token_domains" {
  type        = list(string)
  description = "Token domains for WAF token integration"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}

# ====================================
# Sigmoid Tags Configuration
# ====================================

variable "sigmoid_environment" {
  description = "Sigmoid environment identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_project" {
  description = "Sigmoid project identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_team" {
  description = "Sigmoid team identifier for cost allocation"
  type        = string
  default     = ""
}
