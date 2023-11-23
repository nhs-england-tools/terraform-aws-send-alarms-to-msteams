<!-- BEGIN_TF_DOCS -->

# Terraform AWS Send Alarms to msteams

This module provides the the infrastructure to send Budget and Cloudwatch alarms to msteams.

# Example Usage

```hcl
provider "aws" {
  region = "eu-west-2"
}

resource "random_pet" "this" {
  length = 2
}

module "alarm_module" {
  source                                                        = "../../"
  prefix                                                        = random_pet.this.id
  msteams_webhook_budget_alarm                                  = var.MS_TEAMS_WEB_HOOK
  msteams_webhook_cloudwatch_alarm                              = var.MS_TEAMS_WEB_HOOK
  cloudwatch_retention_in_days                                  = 7
  msteams_webhook_cloudwatch_ssm_lifecycle_ignore_changes_value = true
  msteams_webhook_budget_ssm_lifecycle_ignore_changes_value     = true
}

resource "aws_budgets_budget" "budget" {
  name         = "${random_pet.this.id}-monthly-budget"
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

resource "aws_cloudwatch_metric_alarm" "concurrent_lambdas" {
  alarm_name          = "${random_pet.this.id}-concurrent-lambdas-alarm"
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
```

This example may create resources which cost money. Run ```terraform destroy``` when you don't need the resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | The number of days cloudwatch logs should be kept | `number` | `365` | no |
| <a name="input_lambda_reserved_concurrency"></a> [lambda\_reserved\_concurrency](#input\_lambda\_reserved\_concurrency) | Reserved concurrency is the maximum number of concurrent instances you want to allocate to your function. When a function has reserved concurrency, no other function can use that concurrency | `number` | `1` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | The time in seconds the lambda function is allowed to run before it times out | `number` | `"60"` | no |
| <a name="input_msteams_webhook_budget_alarm"></a> [msteams\_webhook\_budget\_alarm](#input\_msteams\_webhook\_budget\_alarm) | The microsoft teams webhook | `string` | n/a | yes |
| <a name="input_msteams_webhook_budget_ssm_lifecycle_ignore_changes_value"></a> [msteams\_webhook\_budget\_ssm\_lifecycle\_ignore\_changes\_value](#input\_msteams\_webhook\_budget\_ssm\_lifecycle\_ignore\_changes\_value) | True to set the lifecycle {ignore = [value]}, e.i. the ssm parameter will not be overwritten on deploy | `bool` | n/a | yes |
| <a name="input_msteams_webhook_cloudwatch_alarm"></a> [msteams\_webhook\_cloudwatch\_alarm](#input\_msteams\_webhook\_cloudwatch\_alarm) | The microsoft teams webhook | `string` | n/a | yes |
| <a name="input_msteams_webhook_cloudwatch_ssm_lifecycle_ignore_changes_value"></a> [msteams\_webhook\_cloudwatch\_ssm\_lifecycle\_ignore\_changes\_value](#input\_msteams\_webhook\_cloudwatch\_ssm\_lifecycle\_ignore\_changes\_value) | True to set the lifecycle {ignore = [value]}, e.i. the ssm parameter will not be overwritten on deploy | `bool` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The name you want the resources to be prefixed with, for example dev, test, prod | `string` | n/a | yes |

## Modules

No modules.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_alarm_topic_arn"></a> [budget\_alarm\_topic\_arn](#output\_budget\_alarm\_topic\_arn) | The budget alarm topic arn. Subscribe your budget alarms to this topic |
| <a name="output_cloudwatch_alarm_topic_arn"></a> [cloudwatch\_alarm\_topic\_arn](#output\_cloudwatch\_alarm\_topic\_arn) | The cloudwatch alarm topic arn. Subscribe your cloudwatch alarms to this topic |
| <a name="output_msteams_lambda_function_name"></a> [msteams\_lambda\_function\_name](#output\_msteams\_lambda\_function\_name) | n/a |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2.0.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.function_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.cloudwatch_log_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_iam_policy.function_logging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.function_ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.python_dependencies_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.invoke_lambda_permissions_budget_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.invoke_lambda_permissions_cloudwatch_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.budget_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.cloudwatch_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.budget_alerts_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.subscribe_lambda_to_budget_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.subscribe_lambda_to_cloudwatch_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_ssm_parameter.budget_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.budget_webhook_lifecycle_ignore_changes_value](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cloudwatch_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cloudwatch_webhook_lifecycle_ignore_changes_value](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [null_resource.pip_install](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.lambda_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.layer](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.function_logging_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_budget_alerts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

<!-- END_TF_DOCS -->