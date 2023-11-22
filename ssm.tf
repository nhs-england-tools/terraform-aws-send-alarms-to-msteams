resource "aws_ssm_parameter" "budget_webhook" {
  count     = var.msteams_webhook_budget_ssm_lifecycle_ignore_changes_value ? 0 : 1
  name      = "/${var.prefix}/msteams/budget-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_budget_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.overwrite_msteams_webhook_budget_alarm
}

resource "aws_ssm_parameter" "budget_webhook_ifecycle_ignore_changes_value" {
  count     = var.msteams_webhook_budget_ssm_lifecycle_ignore_changes_value ? 1 : 0
  name      = "/${var.prefix}/msteams/budget-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_budget_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.overwrite_msteams_webhook_budget_alarm

  lifecycle {
    ignore_changes = [value]
  }
}


resource "aws_ssm_parameter" "cloudwatch_webhook" {
  count     = var.msteams_webhook_cloudwatch_ssm_lifecycle_ignore_changes_value ? 0 : 1
  name      = "/${var.prefix}/msteams/cloudwatch-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_cloudwatch_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.overwrite_msteams_webhook_cloudwatch_alarm
}

resource "aws_ssm_parameter" "cloudwatch_webhook" {
  count     = var.msteams_webhook_cloudwatch_ssm_lifecycle_ignore_changes_value ? 1 : 0
  name      = "/${var.prefix}/msteams/cloudwatch-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_cloudwatch_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.overwrite_msteams_webhook_cloudwatch_alarm

  lifecycle {
    ignore_changes = [value]
  }
}
