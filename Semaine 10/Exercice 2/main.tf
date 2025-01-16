provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    iam            = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
  }
}

# Il est nécessaire de définir un rôle IAM (Identity and Access Management)
# Ici rôle basique donnant un accès à tous à la fonction lambda
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# On définit la fonction lambda.
# lambda_function.py est le fichier contenant le code (python) de cette fonction
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # Le fichier zip de la fonction Lambda
  filename      = "lambda_function_payload.zip"
  function_name = "lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  # Recherche du handler dans lambda_function.py
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"  # Choisissez la version Python appropriée

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# Il est utile que cette fonction soit accessible directement via une URL
# On peut ainsi envoyer directement une requête avec lynx ou curl à la fonction lambda
resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.test_lambda.function_name
  authorization_type = "NONE"
}