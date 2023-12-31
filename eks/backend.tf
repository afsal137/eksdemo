terraform {
    backend "s3" {
        bucket          = "afstfstate"
        key             = "eksinfra/terraform.tfstate"
        region          = "us-east-1"

        dynamodb_table  = "terraform-locks"
        encrypt         = true
    }
}