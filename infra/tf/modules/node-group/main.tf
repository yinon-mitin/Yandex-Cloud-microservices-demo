resource "yandex_kubernetes_node_group" "test-node" {
  cluster_id = var.cluster_id # Target Kubernetes cluster ID
  name       = var.name # Node group name

  instance_template {
    platform_id = "standard-v1" # VM family used for nodes

    scheduling_policy {
      preemptible = true # Use preemptible nodes to save cost
    }
    network_interface {
      nat        = true # Enable outbound internet via NAT
      subnet_ids = [var.subnet_id] # Subnet where nodes will run
    }
    boot_disk {
      type = var.instance_template_boot_disk_type # Disk type for nodes
      size = var.instance_template_boot_disk_size # Disk size in GB
    }
    resources {
      cores  = var.instance_template_boot_resources_core # vCPU count per node
      memory = var.instance_template_resources_memory # Memory in GB per node
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count # Desired node count for the group
    }
  }
}
