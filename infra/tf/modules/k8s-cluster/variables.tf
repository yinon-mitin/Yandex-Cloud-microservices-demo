variable "name" {} # Cluster name
variable "zone" {} # Zone where the master will run

variable "network_id" {} # VPC network ID for masters
variable "service_account_id" {} # Control plane service account ID
variable "node_service_account_id" {} # Node service account ID
variable "subnet_id" {} # Subnet ID hosting the control plane endpoint
