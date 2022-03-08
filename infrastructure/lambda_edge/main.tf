locals {
  name_suffix = length(var.name_suffix) > 0 ? "-${var.name_suffix}" : ""
  // tags = merge(var.custom_tags, {
  //   "availity:environment"         = var.environment,
  //   "availity:product"             = var.product,
  //   "availity:owner-name"          = var.owner_name,
  //   "availity:owner-contact"       = var.owner_contact,
  //   "availity:runbook-url"         = var.runbook_url,
  //   "availity:data-classification" = var.data_classification,
  //   "availity:cost-center"         = var.cost_center,
  //   "availity:terraform_path"      = var.terraform_path
  // })
}

# cloudfront certificate must be in us-east-1; 
data "aws_acm_certificate" "cert_must_be_us_east1" {
  count     = var.add_domain ? 1 : 0
  domain    = var.certificate_name
  statuses  = ["ISSUED"]
}

resource "aws_lambda_function" "lambda_edge" {
  function_name     = "${var.name_prefix}-sigv4-request-to-s3-role${local.name_suffix}"
  description       = "Sign4 Request to S3 Role"
  filename          = "${path.module}/../../lambda_edge.zip"
  source_code_hash  = filebase64sha256("${path.module}/../../lambda_edge.zip")
  runtime           = "nodejs14.x"
  handler           = "index.handler"
  timeout           = var.timeout
  memory_size       = var.memory_size
  role              = aws_iam_role.lambda_edge_execution_role.arn
  publish           = true # important for lambda@edge versioning
  // tags              = local.tags
}

resource "aws_cloudwatch_log_group" "lambda_edge_log_group" {
  name              = "/aws/lambda/${var.name_prefix}-sigv4-request-to-s3-role${local.name_suffix}"
  # tags              = var.tags
}

data "aws_iam_policy_document" "lambda_edge_execution_role" {
  version     = "2012-10-17"

  statement {
    sid             = "LambdaEdgeEdgeExecutionRole"
    effect          = "Allow"
    actions         = ["sts:AssumeRole"]

    principals {
      type          = "Service"
      identifiers   = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda_edge_execution_role" {
  name                  = "${var.name_prefix}-lambda-edge-execution${local.name_suffix}"
  assume_role_policy    = data.aws_iam_policy_document.lambda_edge_execution_role.json
  // permissions_boundary  = var.permissions_boundary_arn
  // tags                  = local.tags
}

data "aws_iam_policy" "lambda_edge_execution_role" {
  name                  = "AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_edge_execution_role" {
  role                  = aws_iam_role.lambda_edge_execution_role.name
  policy_arn            = data.aws_iam_policy.lambda_edge_execution_role.arn
}

data "aws_iam_policy_document" "lambda_edge_execution_role2" {
  version               = "2012-10-17"

  statement {
    sid                 = "LambdaEdgeExecutionRole"
    effect              = "Allow"
    actions             = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:GetParameter",
      "kms:*",
      "logs:*",
      "cloudwatch:*",
      "s3:*",
      "cloudfront:*"
    ]
    resources           = ["*"]
  }
}

resource "aws_iam_policy" "lambda_edge_execution_role2" {
  name                = "${var.name_prefix}-lambda-edge-execution${local.name_suffix}"
  description         = "lambda edge execution"
  policy              = data.aws_iam_policy_document.lambda_edge_execution_role2.json
}

resource "aws_iam_role_policy_attachment" "execution_role" {
  role                = aws_iam_role.lambda_edge_execution_role.name
  policy_arn          = aws_iam_policy.lambda_edge_execution_role2.arn
}