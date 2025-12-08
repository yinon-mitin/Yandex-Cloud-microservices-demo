# Использование уже существующего ресурса
# data "yandex_vpc_network" "existing-net" {
#   name = var.name
# }
#
# data "yandex_vpc_subnet" "existing-subnet" {
#   subnet_id = var.sub_id
# }

# Создание ресурса
resource "yandex_vpc_network" "test-net" {
  name = var.name # Friendly name for the VPC network
}

resource "yandex_vpc_subnet" "test-subnet" {
  v4_cidr_blocks = var.v4_cidr_blocks # Address space for the subnet
  zone           = var.zone # Availability zone for subnet allocation
  network_id     = yandex_vpc_network.test-net.id # Bind subnet to created VPC
}
