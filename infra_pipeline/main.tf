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

# CodeBuild Project for TF plan
resource "aws_codebuild_project" "terraform_plan" {
  name          = "eksdemo_terraform_plan"
  build_timeout = "15"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/afsal137/eksdemo.git"
    buildspec = "eks/buildspec_plan.yml"
  }
}

# CodeBuild Project for TF apply
resource "aws_codebuild_project" "terraform_apply" {
  name          = "eksdemo_terraform_apply"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/afsal137/eksdemo.git"
    buildspec = "eks/buildspec_apply.yml"
  }
}


# CodePipeline
resource "aws_codepipeline" "terraform_pipeline" {
  name     = "terraform-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      version          = "1"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      output_artifacts = ["source_output"]
      configuration    = {
        Owner      = "afsal137"
        Repo       = "eksdemo"
        Branch     = "staging"
        OAuthToken = data.aws_secretsmanager_secret_version.github_token.secret_string
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name             = "TerraformPlan"
      version          = "1"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      configuration    = {
        ProjectName = aws_codebuild_project.terraform_plan.name
      }
    }
  }

  stage {
    name = "Approval"
    action {
      name      = "ManualApproval"
      version   = "1"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
    }
  }

  stage {
    name = "Apply"
    action {
      name             = "TerraformApply"
      version          = "1"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["plan_output"]
      configuration    = {
        ProjectName = aws_codebuild_project.terraform_apply.name
      }
    }
  }
}

# S3 Bucket for CodePipeline artifacts
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "codepipeline-afs-eksdemo-bucket"
  acl    = "private"
}
