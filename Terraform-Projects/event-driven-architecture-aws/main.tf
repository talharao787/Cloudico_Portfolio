
//lambda creation

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  count  = length(var.lambda_name)

  function_name = "${var.lambda_name[count.index]}-tf-${var.ENV}"
  description   = "My awesome lambda function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  publish       = true

  source_path = "./function/${var.lambda_name[count.index]}/src"
  store_on_s3 = true
  s3_bucket   = "<<build_bucket>>"


  environment_variables = {

    AWS_REGION = var.region
  }

  tags = {
    Environment = "${var.ENV}"
  }
}

//sqs queues creation

module "sqs_queue" {

  source = "terraform-aws-modules/sqs/aws"

  count                   = length(var.sqs_name)
  name                    = "${var.sqs_name[count.index]}-queue-tf-${var.ENV}"
  sqs_managed_sse_enabled = true
  create_queue_policy     = true
  queue_policy_statements = {
    sns = {
      sid     = "SNSPublish"
      actions = ["sqs:SendMessage", "sqs:ReceiveMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]

    }
  }
  tags = {
    Environment = "${var.ENV}"
  }
}

//Policy for Lambas

resource "aws_iam_role_policy" "lambda_policy" {

  depends_on = [module.lambda_function]
  count      = length(var.lambda_name)
  name       = "${var.lambda_name[count.index]}-policy-${var.ENV}"

  role = "${var.lambda_name[count.index]}-tf-${var.ENV}"
  # This policy is exclusively available by my-role
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": "sqs:ListQueues",
        "Resource": "*"
    },
    {
        "Sid": "VisualEditor2",
        "Effect": "Allow",
        "Action": "ec2:CreateNetworkInterface",
        "Resource": "*"
    },
    {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": "sns:*",
            "Resource": "arn:aws:sns:*"
    }

    ]
}
EOF
}

// SNS Topic Creation

module "sns_topic" {
  source = "terraform-aws-modules/sns/aws"
  count  = length(var.sns_name)
  name   = "${var.sns_name[count.index]}-tf-${var.ENV}"

  tags = {
    Environment = "${var.ENV}"
    Terraform   = "true"
  }
}

// SQS Triggers for lambda

resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  depends_on       = [module.sqs_queue, module.lambda_function, aws_iam_role_policy.lambda_policy]
  count            = length(var.sqs_name)
  event_source_arn = "arn:aws:sqs:${var.region}:<account_id>:${var.sqs_name[count.index]}-queue-tf-${var.ENV}"
  function_name    = "${var.sqs_name[count.index]}-tf-${var.ENV}"
}