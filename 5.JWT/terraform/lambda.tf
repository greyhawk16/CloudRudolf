#current region
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


#for getSecretKey lambda

data "archive_file" "getSecretKey_lambda_zip" {
  type = "zip"
  source_file = "lambda_secret_function.py"
  output_path = "lambda_secret_function_payload.zip"
}

resource "aws_iam_role" "jwt-lambda-secret-role" {
  name = "jwt-lambda-secret-role"

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

resource "aws_iam_role_policy" "jwt-lambda-secret-base-policy" {
  name = "jwt-lambda-secret-base-policy"
  role = aws_iam_role.jwt-lambda-secret-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
            	"arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.jwt-getSecretKey-lambda.function_name}:*"
	    ]
        }
    ]
}	
EOF
}

resource "aws_iam_role_policy" "jwt-lambda-secret-secretManager-policy" {
  name = "jwt-lambda-secret-secretManager-policy"
  role = aws_iam_role.jwt-lambda-secret-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
	    ],
            "Resource": "${aws_secretsmanager_secret.jwt-secret.arn}"
        }
    ]
}
EOF
}


resource "aws_lambda_function" "jwt-getSecretKey-lambda" {
  filename = data.archive_file.getSecretKey_lambda_zip.output_path
  function_name = "jwt-getSecretKey-lambda" 
  role = aws_iam_role.jwt-lambda-secret-role.arn
  handler = "lambda_secret_function.lambda_handler" 

  source_code_hash = data.archive_file.getSecretKey_lambda_zip.output_base64sha256

  runtime = "python3.11" 
}


#for printFunction lambda

data "archive_file" "print_lambda_zip" {
  type = "zip"
  source_file = "lambda_print_function.py"
  output_path = "lambda_print_function_payload.zip"
}

resource "aws_iam_role" "jwt-lambda-print-role" {
  name = "jwt-lambda-print-role"

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

resource "aws_iam_role_policy" "jwt-lambda-print-base-policy" {
  name = "jwt-lambda-print-base-policy"
  role = aws_iam_role.jwt-lambda-print-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.jwt-print-lambda.function_name}:*"
            ]
        }
    ]
}
EOF
}

resource "aws_lambda_function" "jwt-print-lambda" {
  filename = data.archive_file.print_lambda_zip.output_path
  function_name = "jwt-print-lambda"
  role = aws_iam_role.jwt-lambda-print-role.arn
  handler = "lambda_print_function.lambda_handler"

  source_code_hash = data.archive_file.print_lambda_zip.output_base64sha256

  runtime = "python3.11"
}

