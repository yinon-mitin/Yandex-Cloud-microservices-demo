variable "name" {} # Name to assign to the VPC network
variable "zone" {} # Target availability zone for subnet creation
# variable "sub_id" { # Используется создание сети, а не использование существующей
#   type        = string
#   description = "ID существующей подсети"
# }
variable "v4_cidr_blocks" {
  type = list(string) # List of CIDR blocks allocated to the subnet
}
