variable "cluster_id" {} # Target cluster to join node group to
variable "name" {} # Name of the node group
variable "subnet_id" {} # Subnet to place worker nodes in
variable "instance_template_boot_disk_type" {
  default = "network-hdd" # Node boot disk type
}
variable "instance_template_boot_disk_size" {
  default = 40 # Boot disk size in GB
}
variable "instance_template_boot_resources_core" {
  default = 2 # Number of vCPUs per node
}
variable "instance_template_resources_memory" {
  default = 8 # Amount of RAM (GB) per node
}
variable "node_count" {
  default = 1 # Node count for the fixed scale policy
}
