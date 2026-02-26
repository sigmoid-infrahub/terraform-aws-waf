variable "name" {
  type        = string
  description = "WAF name"
}

variable "scope" {
  type        = string
  description = "WAF scope (REGIONAL or CLOUDFRONT)"
}

variable "default_action" {
  type        = string
  description = "Default action"
  default     = "allow"
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
