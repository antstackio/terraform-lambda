output "lambda_arn" {
  description = "Function ARN"
  value       = aws_lambda_function.terraform-lambda.invoke_arn
}

output "lambda_name" {
  description = "Function Name"
  value       = aws_lambda_function.terraform-lambda.function_name
}

output "lambda_url" {
  description = "Function URL"
  value       = aws_lambda_function_url.terraform-function-url.function_url
}

