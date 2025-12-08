output "cluster_id" {
  description = "ID Kubernetes-кластера" # Document exported value
  value       = module.k8s_cluster.cluster_id # Bubble up cluster ID from module
}
