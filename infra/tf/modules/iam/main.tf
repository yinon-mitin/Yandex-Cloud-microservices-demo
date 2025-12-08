# Использование уже существующего ресурса
#data "yandex_iam_service_account" "existing-sa" {
#  name = var.name
#}

# Создание ресурса
resource "yandex_iam_service_account" "test-sa" {
  name        = var.name # Service account name
  description = var.description # Human-readable description
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id # Folder to grant permissions in
  member    = "serviceAccount:${yandex_iam_service_account.test-sa.id}" # Bind SA as member
  role      = var.role # IAM role to assign
}
