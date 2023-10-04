<!-- BEGIN_TF_DOCS -->

# Simple example

This Examples crates a budget and cloudwatch alarm and allows them to publish to the sns topics created by the```terraform-aws-send-alarms-to-msteams``` module.

# Example Usage

```shell
terraform init
terraform plan
terraform apply
```

This example may create resources which cost money. Run ```terraform destroy``` when you don't need the resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_MS_TEAMS_WEB_HOOK"></a> [MS\_TEAMS\_WEB\_HOOK](#input\_MS\_TEAMS\_WEB\_HOOK) | The microsoft teams webhook | `string` | n/a | yes |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarm_module"></a> [alarm\_module](#module\_alarm\_module) | ../../cloudwatch_alarms_to_msteams_module | n/a |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.63 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.63 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_cloudwatch_metric_alarm.validation_lambda_failed_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

<!-- END_TF_DOCS -->