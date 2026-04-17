resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = var.scope

  token_domains = var.token_domains

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = lookup(rule.value, "override_action", "none") == "none" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = lookup(rule.value, "override_action", "none") == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          vendor_name = rule.value.managed_rule_group_statement.vendor_name
          name        = rule.value.managed_rule_group_statement.name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "custom_response_body" {
    for_each = var.custom_response_bodies
    content {
      key          = custom_response_body.key
      content      = lookup(custom_response_body.value, "content", "")
      content_type = lookup(custom_response_body.value, "content_type", "TEXT_PLAIN")
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = lookup(var.visibility_config, "cloudwatch_metrics_enabled", true)
    metric_name                = lookup(var.visibility_config, "metric_name", var.name)
    sampled_requests_enabled   = lookup(var.visibility_config, "sampled_requests_enabled", true)
  }

  tags = local.resolved_tags
}
