# Inno Project Microservices (Yandex Cloud Edition)

This repo is a fork of Google’s [**Online Boutique**](https://github.com/GoogleCloudPlatform/microservices-demo) adapted for **Helm**, **Terraform**, **GitLab CI/CD**, and **Yandex Cloud Managed Kubernetes**. Every service is containerized with its own Helm chart and bundled by an umbrella chart in `shopping/`. Use this README as the single entry point to build, provision, and deploy from scratch.

## What you get
- 11 baseline microservices (Go, Java, Node.js, Python, .NET) plus an optional AI shopping assistant.
- Per-service Helm charts + an umbrella chart (`shopping/`) with Bitnami NGINX ingress.
- Terraform modules that create VPC, IAM, Managed K8s cluster, and node group in Yandex Cloud.
- GitLab pipeline that builds/pushes images to Yandex Container Registry (YCR), applies Terraform, and deploys via Helm.

## Services at a glance
- `frontend` (Go, :8080) – Web UI that calls all backends.
- `productcatalogservice` (Go, :3550) – Serves catalog data from `products.json`.
- `cartservice` (.NET, :7070) – Cart storage in Redis (`redis-cart:6379`).
- `checkoutservice` (Go, :5050) – Orchestrates checkout by calling cart, payment, shipping, currency, email, catalog.
- `currencyservice` (Node.js, :7000) – Currency conversion with cached FX.
- `paymentservice` (Node.js, :50051) – Mock payment gateway.
- `shippingservice` (Go, :50051) – Shipping quotes and trackers.
- `emailservice` (Python, :8080) – Mock email confirmations (logs).
- `recommendationservice` (Python, :8080) – Simple recommender.
- `adservice` (Java, :9555) – Context-based ads.
- `shoppingassistantservice` (Python/Flask, :80, optional) – Gemini-powered RAG over AlloyDB.
- `loadgenerator` (Python/Locust, :8089) – Synthetic load to the frontend.
- Supporting: Redis chart via Bitnami (values in `shopping/values.yaml`), NGINX ingress dependency in `shopping/Chart.yaml`.

## Repository layout
- Helm charts: `<service>/<service>/Chart.yaml` and `values.yaml`; umbrella chart at `shopping/`.
- Terraform: reusable modules in `infra/tf/modules/*`; environment wiring in `infra/tf/environment/production/`.
  - `backend.tf` configures Object Storage backend.
  - `terraform.tfvars.example` shows required inputs (`cloud_id`, `folder_id`, `zone`, `node_count`, auth options).
- CI/CD: `.gitlab-ci.yml` builds with `docker buildx`, pushes to YCR, runs Terraform, then `helm upgrade --install`.
- Keys (sample only, not for production): `keys/*.json`.

## Prerequisites
- Yandex Cloud account + Object Storage bucket (for Terraform state), Container Registry, Managed Kubernetes API enabled.
- Service account with roles for Object Storage, Container Registry, and Managed K8s.
- Local tools: `git`, `docker` + Buildx, `kubectl`, `helm`, `terraform`, `yc` CLI, `bash`/`zsh`.
- Exportable creds:
  - YC: `YC_CLOUD_ID`, `YC_FOLDER_ID`, and either `YC_TOKEN` or base64 service-account json `YC_SA_KEY_JSON_B64`.
  - S3 backend: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (for state bucket).

## Getting started from scratch (manual path)
1. **Clone the repo**
   ```sh
   git clone https://github.com/yinon-mitin/microservices-yc-devops inno-project
   cd inno-project
   ```
2. **Configure Terraform**
   ```sh
   cd infra/tf/environment/production
   cp terraform.tfvars.example terraform.tfvars
   # Fill cloud_id, folder_id, zone, node_count, and auth (token or service_account_key_file)
   # Ensure backend.tf points to your Object Storage bucket.
   ```
3. **Authenticate**
   ```sh
   export YC_CLOUD_ID=<cloud>
   export YC_FOLDER_ID=<folder>
   export YC_SA_KEY_JSON_B64=$(base64 -w0 /path/to/sa.json) # or use YC_TOKEN
   export AWS_ACCESS_KEY_ID=<state-bucket-key>
   export AWS_SECRET_ACCESS_KEY=<state-bucket-secret>
   ```
4. **Provision infrastructure**
   ```sh
   terraform init
   terraform apply
   export CLUSTER_ID=$(terraform output -raw cluster_id)
   yc managed-kubernetes cluster get-credentials --id "$CLUSTER_ID" --external --force
   cd ../../../..
   ```
5. **Build and push images (example)**
   ```sh
   export REGISTRY=cr.yandex/<your-registry-id>
   export IMAGE_TAG=dev-$(git rev-parse --short HEAD)
   docker buildx build --platform linux/amd64 -t $REGISTRY/frontend:$IMAGE_TAG frontend --push
   # Repeat for each service (see .gitlab-ci.yml for contexts)
   ```
6. **Deploy with Helm**
   ```sh
   helm dependency update shopping
   helm upgrade shopping ./shopping --install \
     -f shopping/values.yaml \
     --namespace shopping --create-namespace \
     --set adservice.image.tag=$IMAGE_TAG \
     --set cartservice.image.tag=$IMAGE_TAG \
     --set checkoutservice.image.tag=$IMAGE_TAG \
     --set currencyservice.image.tag=$IMAGE_TAG \
     --set emailservice.image.tag=$IMAGE_TAG \
     --set frontend.image.tag=$IMAGE_TAG \
     --set paymentservice.image.tag=$IMAGE_TAG \
     --set productcatalogservice.image.tag=$IMAGE_TAG \
     --set recommendationservice.image.tag=$IMAGE_TAG \
     --set shippingservice.image.tag=$IMAGE_TAG
   # Add --set shoppingassistantservice.image.tag=$IMAGE_TAG if enabling the assistant
   ```
7. **Validate**
   ```sh
   kubectl get pods -n shopping
   kubectl get svc -n shopping
   # For quick testing:
   kubectl port-forward svc/frontend 8080:80 -n shopping
   ```

## Optional: AI shopping assistant
- Location: `shoppingassistantservice/`.
- Needs Google Gemini + AlloyDB. Required env vars: `PROJECT_ID`, `REGION`, `ALLOYDB_DATABASE_NAME`, `ALLOYDB_TABLE_NAME`, `ALLOYDB_CLUSTER_NAME`, `ALLOYDB_INSTANCE_NAME`, `ALLOYDB_SECRET_NAME`.
- Secret with DB password must exist in Google Secret Manager (`ALLOYDB_SECRET_NAME` latest version).
- Enable by uncommenting the subchart in `shopping/Chart.yaml` and `shopping/values.yaml` and providing image tag + env/secret settings.

## CI/CD (GitLab)
- Variables to set in GitLab:
  - `REGISTRY_ID` (YCR registry ID), `YC_SA_KEY_JSON_B64`, `YC_CLOUD_ID`, `YC_FOLDER_ID`
  - `S3_ACCESS_KEY`, `S3_SECRET_KEY` for Terraform backend
  - Optional overrides: `ZONE`, `NODE_COUNT`
- Pipeline stages:
  1. Build images for each service with `docker buildx` (amd64) and push to `cr.yandex/$REGISTRY_ID`.
  2. Install Terraform + YC CLI, apply infra in `infra/tf/environment/production`.
  3. Pull kubeconfig with `yc managed-kubernetes cluster get-credentials`.
  4. Helm upgrade/install umbrella chart with freshly built tags.

## How this differs from Google’s original
- Yandex Cloud as the target platform (Managed K8s, Object Storage, Container Registry).
- Terraform IaC replaces GKE-focused provisioning.
- Per-service Helm charts + umbrella chart for deployment instead of static manifests.
- GitLab CI/CD workflow for build + infra + Helm release.
- Optional AI shopping assistant (Gemini + AlloyDB vector store).
- Bitnami NGINX ingress bundled as a dependency.
