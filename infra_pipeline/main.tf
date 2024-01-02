provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

data "aws_secretsmanager_secret" "github_token" {
  name = "eksdemogithub"

}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

provider "github" {
  token = data.aws_secretsmanager_secret_version.github_token.secret_string
}