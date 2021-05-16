# We need : 
# Lambda  with  simple basic role
# Method to store data 

resource "aws_iam_role" "lambda_role" {
  name = "ewelink"

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

resource "aws_iam_policy" "lambda_policy" {
    name = "ewelink"
    path = "/"
    description = "Logging Rights for Lambda"
    policy = jsonencode({
        "Version" = "2012-10-17"
        "Statement" = [
            {
                "Effect" = "Allow",
                "Action" = "logs:CreateLogGroup",
                "Resource" = "arn:aws:logs:eu-west-1:591403025801:*"
            },
            {
                "Effect" = "Allow"
                "Action" = [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource" = [
                    "arn:aws:logs:eu-west-1:591403025801:log-group:/aws/lambda/ewelink:*"
                ]
            }
        ]    
    })
}

resource "aws_iam_role_policy_attachment" "role_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/payload.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "payload.zip"
  function_name = "ewelink"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs14.x"

  environment {
    variables = {
      email = "adam.kurowski.ewelink@darevee.pl",
      password = "3ESCAFLONE",
      region = "us"
    }
  }
}