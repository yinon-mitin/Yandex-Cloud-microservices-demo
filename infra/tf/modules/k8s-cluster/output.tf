# output "cluster_id" { # Экспорт ID существующего кластера
#   value = data.yandex_kubernetes_cluster.existing.id
# }

output "cluster_id" { # Экспорт ID нового кластера
  description = "ID Kubernetes-кластера" # Help text for consumers
  value       = yandex_kubernetes_cluster.prod-k8s.id # Control plane identifier
}
