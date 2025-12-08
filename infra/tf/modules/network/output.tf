# Экспорт существующего ресурса
# output "network_id" {
#   description = "ID существующей VPC-сети"
#   value = data.yandex_vpc_network.existing-net.id
# }
# output "subnet_id" {
#   description = "ID существующей подсети"
#   value = data.yandex_vpc_subnet.existing-subnet.id
# }

# Экспорт созданного ресурса
output "network_id" {
  value = yandex_vpc_network.test-net.id # Expose created VPC network ID to callers
}
output "subnet_id" {
  value = yandex_vpc_subnet.test-subnet.id # Expose created subnet ID to callers
}
