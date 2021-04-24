# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = var.aws_region
}
resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_lambda_function" "greet_lambda" {
  function_name = "greet_lambda"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "greet_lambda.lambda_handler"
  s3_bucket = "terraform-badr-lambda-udacity"
  s3_key    = "v1.0.0/terraformLambdaCode.zip"
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime = "python3.8"
  environment {
    variables = {
      greeting = "Hello from Lambda created by Terraform"
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.greet_lambda_Logs,
  ]
}
# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "greet_lambda_Logs" {
  name              = "/aws/lambda/greet_lambda"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
