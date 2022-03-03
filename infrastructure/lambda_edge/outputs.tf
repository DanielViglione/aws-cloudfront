output "certificate_arn" {
  value   = var.add_domain ? data.aws_acm_certificate.cert_must_be_us_east1[0].arn : ""
}

output "lambda_edge_execution_role" {
  value     = aws_iam_role.lambda_edge_execution_role.name
}

output "lambda_edge_execution_role_arn" {
  value     = aws_iam_role.lambda_edge_execution_role.arn
}

output "function" {
  value   = aws_lambda_function.lambda_edge.function_name
}

output "function_arn" {
  value   = aws_lambda_function.lambda_edge.arn
}

# need to explicitly version the function. CloudFront trigger doesn’t work with the $LATEST function
output "function_qualified_arn" {
  value   = aws_lambda_function.lambda_edge.qualified_arn
}

output "function_log_group" {
  value   = aws_cloudwatch_log_group.lambda_edge_log_group.name
}