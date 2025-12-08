terraform {
  required_providers {
    yandex = { # Declare Yandex Cloud provider dependency
      source = "yandex-cloud/yandex" # Provider source in registry
    }
  }
  required_version = ">= 0.13" # Minimal Terraform version supported
}
