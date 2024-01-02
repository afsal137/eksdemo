# S3 Bucket for CodePipeline artifacts
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "codepipeline-afs-eksdemo-bucket"
  acl    = "private"
}