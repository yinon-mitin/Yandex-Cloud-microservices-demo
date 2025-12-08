# Changelog

- Added per-service Helm charts and umbrella chart (`shopping/`) for Kubernetes deployments.
- Migrated infrastructure to Yandex Cloud using Terraform modules (VPC, IAM, Managed K8s, node group).
- Switched container registry defaults to Yandex Container Registry and unified image tagging via CI (`IMAGE_TAG`).
- Introduced GitLab CI/CD to build images with Buildx, apply Terraform, and deploy Helm releases automatically.
- Bundled Bitnami NGINX ingress dependency for demo ingress.
- And much more!