provider "aws" {
    region = "us-east-1"
}


## S3 Bucket for storing tfstate
resource "aws_s3_bucket" "tfstate" {
    bucket = "afstfstate"
}


resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

## DynamoDB for tfstate locing
resource "aws_dynamodb_table" "terraform_locks" {
    name            = "terraform-locks"
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name        = "LockID"
        type        = "S"
    }
  
}

## Generating password for DB and storing it as a secret in Secrets Manager
resource "random_password" "eksdemopostgres"{
  length           = 16
  special          = true
}

resource "aws_secretsmanager_secret" "eksdemopostgres" {
  name = "eksdemopostgres-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.eksdemopostgres.id
  secret_string = random_password.eksdemopostgres.result
}
