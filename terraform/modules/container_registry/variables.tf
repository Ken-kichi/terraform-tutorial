# どの Azure リージョンにリソースを作成するかを指定します
# 例: "Sweden Central", "East US", "Japan East" など
variable "location" {
  description = "Azure リージョン名（例: Sweden Central）"
  type        = string
}

# すべてのリソースをまとめて管理するための「リソースグループ」の名前です
# Azure 上での「プロジェクトフォルダ」のようなものです
variable "resource_group_name" {
  description = "作成するリソースをまとめるリソースグループ名"
  type        = string
}

# Azure Key Vault の名前を指定します
# Key Vault はシークレットやAPIキーを安全に保管するサービスです
variable "key_vault_name" {
  description = "Azure Key Vault の名前（グローバルで一意）"
  type        = string
}

# 一般的な名前を受け取るための変数です（モジュールによって ACR や OpenAI などに使います）
# 名前に応じて役割が変わるので、モジュール内の使い方に注意してください
variable "name" {
  description = "リソース（例: ACR や OpenAI アカウントなど）の名前"
  type        = string
}
