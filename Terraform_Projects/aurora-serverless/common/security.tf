data "aws_iam_policy_document" "db_kms_key_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
      ]
    }
    resources = ["*"]
  }
}

resource "aws_kms_key" "db_kms_key" {
  description             = "${local.full_name}-rds-kms-key"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.db_kms_key_policy.json
}

resource "random_string" "db_username" {
  length  = 8
  special = false
  upper   = false
  numeric = false
  keepers = {
    pass_version = 1
  }
}

resource "random_password" "db_password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
  keepers = {
    pass_version = 1
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${local.full_name}-database-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_secret_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    DATABASE_USER     = random_string.db_username.result
    DATABASE_PASSWORD = random_password.db_password.result
  })
}
