## Configure S3 Backend

terraform {
    backend "s3" {
        bucket          = "afstfstate"
        key             = "infrapipeline/terraform.tfstate"
        region          = "us-east-1"

        dynamodb_table  = "terraform-locks"
        encrypt         = true
    }
}
