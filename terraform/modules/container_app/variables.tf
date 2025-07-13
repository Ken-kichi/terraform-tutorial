variable "location" {
  description = "デプロイする Azure リージョン名（例: Sweden Central）"
  type        = string
}

variable "resource_group_name" {
  description = "リソースグループの名前"
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault の名前"
  type        = string
}

variable "container_app_name" {
  description = "Container App の名前"
  type        = string
}
