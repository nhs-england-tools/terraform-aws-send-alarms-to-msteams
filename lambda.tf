data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda_archive/msteams.zip"
}

resource "null_resource" "pip_install" {
  triggers = {
    mesh_aws_client_dependencies = timestamp()
  }

  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/layer && pip install -r ${path.module}/lambda/requirements.txt -t ${path.module}/layer/python"
  }
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/layer"
  output_path = "${path.module}/layer.zip"
  depends_on  = [null_resource.pip_install]
}

resource "aws_lambda_layer_version" "python_dependencies_layer" {
  layer_name          = "${var.prefix}-msteams-layer"
  filename            = data.archive_file.layer.output_path
  source_code_hash    = data.archive_file.layer.output_base64sha256
  compatible_runtimes = ["python3.9", "python3.8", "python3.7"]
}

resource "aws_lambda_function" "lambda_function" {
  function_name                  = "${var.prefix}-msteams"
  filename                       = data.archive_file.lambda_function.output_path
  source_code_hash               = data.archive_file.lambda_function.output_base64sha256
  role                           = aws_iam_role.iam_for_lambda.arn
  handler                        = "lambda_handler.lambda_handler"
  runtime                        = "python3.9"
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.lambda_reserved_concurrency

  layers = [aws_lambda_layer_version.python_dependencies_layer.arn]

  environment {
    variables = {
      BUDGET_SNS_TOPIC_ARN        = aws_sns_topic.budget_alarm_topic.arn
      CLOUDWATCH_SNS_TOPIC_ARN    = aws_sns_topic.cloudwatch_alarm_topic.arn
      BUDGET_WEBHOOK_SSM_NAME     = local.ssm_budget_webhook_name
      CLOUDWATCH_WEBHOOK_SSM_NAME = local.ssm_cloudwatch_webhook_name
      MSTEAMS_ACTIVITY_SUBTITLE   = var.msteams_activity_subtitle
    }
  }

  tracing_config {
    mode = "Active"
  }
}
