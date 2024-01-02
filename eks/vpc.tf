module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "afsvpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  intra_subnets   = ["10.0.111.0/24", "10.0.112.0/24", "10.0.113.0/24"]
  database_subnets = ["10.0.211.0/24", "10.0.212.0/24", "10.0.213.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  create_database_subnet_group = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}