terraform {
  required_providers {
    yandex = { # Declare Yandex Cloud provider dependency
      source = "yandex-cloud/yandex" # Provider source in registry
    }
  }
  required_version = ">= 0.13" # Minimal Terraform version supported
}

provider "yandex" {
  # Prefer providing YC_TOKEN/YC_CLOUD_ID/YC_FOLDER_ID environment variables.
  # The variables declared in variables.tf allow overriding via tfvars as needed.
  # token = var.yandex_token != "" ? var.yandex_token : null
  # Only use the service account key when no token is provided to avoid provider conflicts.
  service_account_key_file = var.yandex_token == "" && var.service_account_key_file != "" ? var.service_account_key_file : null # Use SA key only when no OAuth token supplied
  cloud_id                 = var.cloud_id # Target cloud ID
  folder_id                = var.folder_id # Target folder ID
  zone                     = var.zone # Default zone for resources
}
