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