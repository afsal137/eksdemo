provider "aws" {
    region = "us-east-1"
    alias  = "virginia"
}

locals {
  cluster_version = "1.27"
  region = "us-east-1"
  name   = "afsdemo"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  container_name = "todoclient"
  container_port = 3000

  tags = {
    Terraform = "true"
    Environment = "dev"
    Project = "afsdemo"
  }

  repos = {
    "todoclient" = {}
    "todoserver" = {}
  }
}