# The only way to control lifecycle through input parameters is through count
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

# The only way to control lifecycle through input parameters is through count
resource "aws_ssm_parameter" "cloudwatch_webhook" {
  count     = var.msteams_webhook_cloudwatch_ssm_lifecycle_ignore_changes_value ? 0 : 1
  name      = "/${var.prefix}/msteams/cloudwatch-webhook"
  type      = "SecureString"
  value     = var.msteams_webhook_cloudwatch_alarm
  key_id    = "alias/aws/ssm"
  overwrite = var.overwrite_msteams_webhook_cloudwatch_alarm
}

resource "aws_ssm_parameter" "cloudwatch_webhook_Zifecycle_ignore_changes_value" {
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

# Get the arn and name of the ssm parameter that was generated for ease of use later
locals {
  ssm_budget_webhook_name = compact([
    try(aws_ssm_parameter.budget_webhook[0].name, null),
    try(aws_ssm_parameter.budget_webhook_ifecycle_ignore_changes_value[0].name, null)
  ])[0]

  ssm_cloudwatch_webhook_name = compact([
    try(aws_ssm_parameter.cloudwatch_webhook[0].name, null),
    try(aws_ssm_parameter.cloudwatch_webhook_ifecycle_ignore_changes_value[0].name, null)
  ])[0]

  ssm_budget_webhook_arn = compact([
    try(aws_ssm_parameter.budget_webhook[0].arn, null),
    try(aws_ssm_parameter.budget_webhook_ifecycle_ignore_changes_value[0].arn, null)
  ])[0]

  ssm_cloudwatch_webhook_arn = compact([
    try(aws_ssm_parameter.cloudwatch_webhook[0].arn, null),
    try(aws_ssm_parameter.cloudwatch_webhook_ifecycle_ignore_changes_value[0].arn, null)
  ])[0]
}
