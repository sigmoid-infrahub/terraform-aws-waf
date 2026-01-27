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

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
