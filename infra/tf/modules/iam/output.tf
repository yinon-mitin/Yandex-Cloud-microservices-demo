# Экспорт существующего ресурса
#output "sa_id" {
#  value = data.yandex_iam_service_account.existing-sa.id
#}

# Экспорт созданного ресурса
output "sa_id" {
  value = yandex_iam_service_account.test-sa.id # Expose created service account ID
}
