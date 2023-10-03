##########################
#### Budget Alarm SNS ####
##########################
resource "aws_sns_topic" "budget_alarm_topic" {
  name              = "${var.prefix}-budget-alarm-topic"
}

resource "aws_lambda_permission" "invoke_lambda_permissions_budget_alarm_topic" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.budget_alarm_topic.arn
}

resource "aws_sns_topic_subscription" "subscribe_lambda_to_budget_alarm_topic" {
  endpoint  = aws_lambda_function.lambda_function.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.budget_alarm_topic.arn
}

resource "aws_sns_topic_policy" "budget_alerts_policy" {
  arn    = aws_sns_topic.budget_alarm_topic.arn
  policy = data.aws_iam_policy_document.sns_budget_alerts.json
}

data "aws_iam_policy_document" "sns_budget_alerts" {
  statement {
    sid = "AWSBudgetsAlerts"

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.budget_alarm_topic.arn,
    ]
  }
}


##########################
## CloudWatch Alarm SNS ##
##########################
resource "aws_sns_topic" "cloudwatch_alarm_topic" {
  name              = "${var.prefix}-cloudwatch-alarm-topic"
}

resource "aws_lambda_permission" "invoke_lambda_permissions_cloudwatch_alarm_topic" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cloudwatch_alarm_topic.arn
}

resource "aws_sns_topic_subscription" "subscribe_lambda_to_cloudwatch_alarm_topic" {
  endpoint  = aws_lambda_function.lambda_function.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.cloudwatch_alarm_topic.arn
}
