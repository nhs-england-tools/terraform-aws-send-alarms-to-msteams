variable "prefix" {
  description = "The name you want the resources to be prefixed with, for example dev, test, prod"
  type        = string
}

variable "lambda_reserved_concurrency" {
  description = "Reserved concurrency is the maximum number of concurrent instances you want to allocate to your function. When a function has reserved concurrency, no other function can use that concurrency"
  default     = 1
  type        = number
}

variable "lambda_timeout" {
  description = "The time in seconds the lambda function is allowed to run before it times out"
  default     = "60"
  type        = number
}

variable "msteams_webhook_budget_alarm" {
  description = "The microsoft teams webhook "
  sensitive   = true
  type        = string
}

variable "msteams_webhook_cloudwatch_alarm" {
  description = "The microsoft teams webhook "
  sensitive   = true
  type        = string
}

variable "cloudwatch_retention_in_days" {
  type        = number
  default     = 365
  description = "The number of days cloudwatch logs should be kept"
}

variable "msteams_webhook_cloudwatch_ssm_lifecycle_ignore_changes_value" {
  type        = bool
  description = "True to set the lifecycle {ignore = [value]}, e.i. the ssm parameter will not be overwritten on deploy"
}

variable "msteams_webhook_budget_ssm_lifecycle_ignore_changes_value" {
  type        = bool
  description = "True to set the lifecycle {ignore = [value]}, e.i. the ssm parameter will not be overwritten on deploy"
}
