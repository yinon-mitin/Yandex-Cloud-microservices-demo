module "network" {
  source         = "../../modules/network" # Path to reusable VPC module
  name           = "prod-vpc" # Name for the created VPC
  zone           = var.zone # Zone where subnet will live
  v4_cidr_blocks = ["172.16.0.0/16"] # CIDR for the primary subnet
}

module "iam" {
  source      = "../../modules/iam" # Path to IAM module
  name        = "k8s-prod" # Service account name
  description = "service account to manage k8s" # SA description
  folder_id   = var.folder_id # Folder where permissions are granted
  role        = "editor" # IAM role assigned to the SA
}

module "k8s_cluster" {
  source = "../../modules/k8s-cluster" # Path to Kubernetes cluster module
  name   = "zonal-k8s-prod" # Friendly cluster name
  zone   = var.zone # Zone for control plane

  # Использование уже существующего ресурса
#   network_id              = module.network.network_id
#   subnet_id               = module.network.subnet_id
#   service_account_id      = module.iam.sa_id
#   node_service_account_id = module.iam.sa_id
#
  # Создание ресурса
  network_id              = module.network.network_id # Connect masters to created VPC
  subnet_id               = module.network.subnet_id # Use created subnet for API endpoint
  service_account_id      = module.iam.sa_id # Control plane SA
  node_service_account_id = module.iam.sa_id # Node SA
}

module "node_group" {
  source     = "../../modules/node-group" # Path to node group module
  name       = "prod-k8s-node-group" # Node group name
  node_count = var.node_count # Fixed number of nodes
  # cluster_id = data.yandex_kubernetes_cluster.existing.id # Использование существующего кластера
  cluster_id = module.k8s_cluster.cluster_id # Использование нового кластера
  subnet_id  = module.network.subnet_id # Subnet for worker nodes
}
