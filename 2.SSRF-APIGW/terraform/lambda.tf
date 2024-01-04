
data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_iam_role" "cr-ssrf-lambda-role" {
  name = "cr-ssrf-lambda-role"

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

resource "aws_iam_role_policy" "cr-ssrf-lambda-role-policy" {
  name = "cr-ssrf-lambda-role-policy"
  role = aws_iam_role.cr-ssrf-lambda-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_lambda_function" "cr-ssrf-lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "cr-ssrf-lambda" 
  role = aws_iam_role.cr-ssrf-lambda-role.arn
  handler = "lambda_function.lambda_handler" 

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "python3.11" 
}
