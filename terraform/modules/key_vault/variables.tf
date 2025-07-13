# Azure リージョンを指定する変数
# 例: "Sweden Central", "East US", "Japan East" など
# すべてのリソースはこの場所に作成されます
variable "location" {
  description = "リソースを作成する Azure リージョン名（例: Sweden Central）"
  type        = string
}

# 作成したリソースをまとめる「リソースグループ」の名前
# プロジェクトの単位で管理するためのグループです
variable "resource_group_name" {
  description = "Azure リソースグループの名前（すべてのリソースをこの中に作成）"
  type        = string
}

# Azure Key Vault の名前（グローバルで一意）
# APIキーやパスワードなどの機密情報を安全に保管するサービスです
variable "key_vault_name" {
  description = "作成する Azure Key Vault の名前（3〜24文字、英数字とハイフンのみ）"
  type        = string
}
