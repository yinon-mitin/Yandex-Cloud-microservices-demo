output "node_count" {
  value = length(yandex_kubernetes_node_group.test-node) # Report number of node groups created
}
