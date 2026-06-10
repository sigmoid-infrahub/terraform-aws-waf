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
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.sampled_requests_enabled
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
    cloudwatch_metrics_enabled = lookup(var.visibility_config, "cloudwatch_metrics_enabled", var.cloudwatch_metrics_enabled)
    metric_name                = lookup(var.visibility_config, "metric_name", var.name)
    sampled_requests_enabled   = lookup(var.visibility_config, "sampled_requests_enabled", var.sampled_requests_enabled)
  }

  tags = local.resolved_tags
}

resource "aws_cloudwatch_log_group" "waf" {
  count = var.enable_logging ? 1 : 0

  name              = "aws-waf-logs-${var.name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = local.has_log_kms_key ? var.log_kms_key_id : null

  tags = local.resolved_tags
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count = var.enable_logging ? 1 : 0

  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf[0].arn]
}
