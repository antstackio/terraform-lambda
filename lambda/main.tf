data "aws_iam_policy_document" "assume_role-terraform" {
  version = "2012-10-17"
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda-terraform" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role-terraform.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_lambda-terraform.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "zip-terraform" {
  type        = "zip"
  source_file = "${path.module}/src/index.mjs"
  output_path = "${path.module}/index.zip"
}

resource "aws_lambda_function" "terraform-lambda" {
  filename         = "${path.module}/index.zip"
  function_name    = "terraform-lambda-varun" //Change the name before deploying
  role             = aws_iam_role.iam_for_lambda-terraform.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.zip-terraform.output_base64sha256
}

resource "aws_lambda_function_url" "terraform-function-url" {
  function_name      = aws_lambda_function.terraform-lambda.function_name
  authorization_type = "NONE"
}

resource "aws_cloudwatch_log_group" "terraform-logs" {
  name              = "/aws/lambda/${aws_lambda_function.terraform-lambda.function_name}"
  retention_in_days = 30
}
