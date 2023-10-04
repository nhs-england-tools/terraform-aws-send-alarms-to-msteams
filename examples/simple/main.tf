module "alarm_module" {
  source                           = "../../cloudwatch_alarms_to_msteams_module"
  prefix                           = local.workspace
  msteams_webhook_budget_alarm     = var.MS_TEAMS_WEB_HOOK
  msteams_webhook_cloudwatch_alarm = var.MS_TEAMS_WEB_HOOK
  cloudwatch_retention_in_days     = 7
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_budgets_budget" "budget" {
  name         = "monthly-budget"
  budget_type  = "COST"
  limit_amount = "50"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 100
    threshold_type      = "PERCENTAGE"
    notification_type   = "FORECASTED"
    subscriber_sns_topic_arns = [
      module.alarm_module.budget_alarm_topic_arn
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "validation_lambda_failed_alarm" {
  alarm_name          = "lambda-failure-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ConcurrentExecutions"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions = [
    module.alarm_module.cloudwatch_alarm_topic_arn
  ]
  alarm_description  = "https://nhsd-confluence.digital.nhs.uk/display/SPACE/PlaybookA"
  treat_missing_data = "notBreaching"

}
