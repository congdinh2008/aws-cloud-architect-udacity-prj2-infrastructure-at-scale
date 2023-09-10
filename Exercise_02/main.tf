# TODO: Designate a cloud provider, region, and credentials
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

locals {
  name   = "udacitypr2"
  region = var.region
  azs    = slice(data.aws_availability_zones.available.names, 0, 3)

  lambda_zip_file = "./lambda.py.zip"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-rds"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

################################################################################
# TODO: Zip function file
################################################################################
data "archive_file" "greet_lambda" {
  type        = "zip"
  source_file = "./lambda.py"
  output_path = local.lambda_zip_file
}

################################################################################
# TODO: Create iam role for lambda function
################################################################################
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

################################################################################
# TODO: Create lambda function from zip file
################################################################################
resource "aws_lambda_function" "greet_lambda" {
  filename      = local.lambda_zip_file
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_handler"

  runtime = "python3.9"

  environment {
    variables = {
      greeting = var.lambda_function_name
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "Lambda loging IAM policy"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
