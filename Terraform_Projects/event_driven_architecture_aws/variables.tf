
variable "lambda_name" {
  type    = list(any)
  default = ["function_1", "function_2"]
}

variable "sqs_name" {
  type    = list(any)
  default = ["sqs_1", "sqs_2"]
}

variable "sns_name" {
  type    = list(any)
  default = ["sns_1", "sns_2"]
}

variable "region" {}
variable "ENV" {}
