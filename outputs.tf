output "cloudwatch_alarm_topic_arn" {
  value       = aws_sns_topic.cloudwatch_alarm_topic.arn
  description = "The cloudwatch alarm topic arn. Subscribe your cloudwatch alarms to this topic"
}

output "budget_alarm_topic_arn" {
  value       = aws_sns_topic.budget_alarm_topic.arn
  description = "The budget alarm topic arn. Subscribe your budget alarms to this topic"
}

output "msteams_lambda_function_name" {
  value = aws_lambda_function.lambda_function.function_name
}
