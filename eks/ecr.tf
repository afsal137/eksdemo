module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  for_each = local.repos

  repository_name = "${local.name}/${each.key}"
  repository_image_tag_mutability = "MUTABLE"
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.tags
}

data "aws_caller_identity" "current" {}