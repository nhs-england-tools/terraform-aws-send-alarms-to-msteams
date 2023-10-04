resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${var.prefix}-msteams"
  retention_in_days = var.cloudwatch_retention_in_days

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = "${var.prefix}-msteams-cloudwatch-log-stream"
  log_group_name = aws_cloudwatch_log_group.function_log_group.name
}
