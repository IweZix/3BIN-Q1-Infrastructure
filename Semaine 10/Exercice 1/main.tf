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

# Définition d'un Bucket S3
# Son nom de référence dans ce fichier sera mybucket (attention pas underscore dans nom de référence !)
resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucketname"
}

# Définition d'une ACL (Access Control List) pour notre bucket
# Accès en lecture pour tous
resource "aws_s3_bucket_acl" "public_access_acl" {
# Remarquez la référence à note bucket -> mybucket après aws_s3_bucket
  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Uploader un fichier dans le bucket
resource "aws_s3_object" "index_html" {
# Donner la référence vers le bucket
  bucket = "mybucketname"
  key    = "index.html"
  source = "./index.html"
# Le bucket doit être créé avant de pouvoir uploader un fichier
  depends_on = [aws_s3_bucket.mybucket]
}