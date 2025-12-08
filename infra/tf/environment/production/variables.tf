variable "yandex_token" {
  description = "Yandex Cloud OAuth token; leave empty to rely on YC_TOKEN env var."
  type        = string # OAuth token string if used
  sensitive   = true # Avoid logging the token
  default     = "" # Empty means rely on env or SA key
}

variable "cloud_id" {
  description = "Yandex Cloud cloud_id; can also be set via YC_CLOUD_ID env var."
  type        = string # Target cloud identifier
}

variable "folder_id" {
  description = "Target folder for provisioned resources; can come from YC_FOLDER_ID."
  type        = string # Folder identifier inside the cloud
}

variable "zone" {
  description = "Default zone for cluster resources."
  type        = string # Availability zone code
}

variable "node_count" {
  description = "Number of worker nodes in the managed node group."
  type        = number # Fixed node count used by node group module
}

variable "service_account_key_file" {
  description = "Path to a Yandex Cloud service account key file for provider auth."
  type        = string # Local path to SA credentials JSON
  default     = "" # Empty to prefer OAuth token
}
