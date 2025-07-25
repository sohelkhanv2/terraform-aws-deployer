provider "aws" {
  region = "us-east-2" 
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "terraform_role_v3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "terraform_lambda" {
  function_name = "terraform_lambda_v3"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "list_address_files.zip"
  source_code_hash = filebase64sha256("list_address_files.zip")
}