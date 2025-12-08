# Использование существующего кластера
# data "yandex_kubernetes_cluster" "existing" {
#   name = "zonal-k8s-prod"

# Создание нового кластера
resource "yandex_kubernetes_cluster" "prod-k8s" {
  name                    = var.name                      # Friendly cluster name
  network_id              = var.network_id                # VPC network to attach masters
  node_service_account_id = var.node_service_account_id   # SA for node operations
  service_account_id      = var.service_account_id        # SA for master control plane

  master {
    master_location {
      zone      = var.zone        # Availability zone for the control plane
      subnet_id = var.subnet_id   # Subnet for master endpoint
    }
    public_ip = true # Expose Kubernetes API over the internet
  }
}
