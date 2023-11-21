resource "aws_ssm_parameter" "budget_webhook" {
  name      = "/${var.prefix}/msteams/budget-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_budget_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.overwrite_msteams_webhook_budget_alarm
}

resource "aws_ssm_parameter" "cloudwatch_webhook" {
  name      = "/${var.prefix}/msteams/cloudwatch-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_cloudwatch_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.msteams_webhook_cloudwatch_alarm
}
