resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.prefix}-msteams-iam-for-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name = "${var.prefix}-msteams-iam-for-lambda"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "LambdaAssumePolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "function_logging_policy_document" {
  statement {
    sid    = "AllowCloudWatchLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.function_log_group.arn}:*", ]
  }
  statement {
    sid       = "AllowXRayLogging"
    effect    = "Allow"
    actions   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
    resources = ["*"]
  }
}


resource "aws_iam_policy" "function_logging_policy" {
  name        = "${var.prefix}-msteams-function-logging-policy"
  description = "A logging function document"
  policy      = data.aws_iam_policy_document.function_logging_policy_document.json

  tags = {
    Name = "${var.prefix}-msteams-function-logging-policy"
  }
}

resource "aws_iam_role_policy_attachment" "function_ssm_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    actions = [
      "ssm:getparameter",
      "ssm:getparameters",
    ]
    resources = [
      local.ssm_budget_webhook_arn,
      local.ssm_cloudwatch_webhook_arn
    ]
  }
}


resource "aws_iam_policy" "ssm_policy" {
  name        = "${var.prefix}-msteams-ssm-policy"
  description = "A ssm policy document"
  policy      = data.aws_iam_policy_document.ssm_policy.json

  tags = {
    Name = "${var.prefix}-msteams-ssm-policy"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}
