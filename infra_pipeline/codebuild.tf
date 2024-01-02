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