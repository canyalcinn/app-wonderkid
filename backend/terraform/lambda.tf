resource "aws_lambda_function" "analyze_potential" {
  function_name = "analyze_potential"
  s3_bucket     = aws_s3_bucket.lambda_code_bucket.id
  s3_key        = "lambda_code.zip"
  handler       = "analyze_potential.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 60

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.wonderkid_potential.name
    }
  }
}

# Lambda için IAM rolü
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda'nın DynamoDB ve S3'e erişebilmesi için gerekli politika
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_s3_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "lambda_role" {
  name = "wonderkid-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "wonderkid-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_lambda_function" "analyzepotential" {
  function_name = "analyzepotential"
  role          = aws_iam_role.lambda_role.arn
  handler       = "analyze_potential.lambda_handler" # analyze_potential.py'deki handler fonksiyonu
  runtime       = "python3.9"

  # S3'ten zip dosyasını al
  s3_bucket = "wonderkid-lambda-code"
  s3_key    = "lambda_code.zip"

  # Lambda environment variables (opsiyonel)
  environment {
    variables = {
      BUCKET_NAME = "your-backend-s3-bucket-name"
    }
  }

}
