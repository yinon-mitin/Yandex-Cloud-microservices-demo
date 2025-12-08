terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net" # Point S3 backend to YC Object Storage
    }

    bucket = "tf-state-inno-project" # Bucket storing Terraform state
    region = "ru-central1" # YC region for the bucket
    key    = "production/terraform.tfstate" # Path/key for this environment's state

    skip_region_validation      = true # YC endpoint not in AWS region list
    skip_credentials_validation = true # Skip AWS-specific credential checks
    skip_requesting_account_id  = true # YC S3 is AWS-compatible without account ID
  }
}
