# 作成するリソースの名前を指定する変数です
# 例えば、リソースグループ名やKey Vault名などに使われます
# 名前は Azure 上で一意である必要があるものもあります
variable "name" {
  description = "Azure リソースの名前（リソースグループやサービス名など）"
  type        = string
}

# リソースを配置する Azure のリージョン（地域）を指定します
# 例: Japan East, Sweden Central, East US など
variable "location" {
  description = "Azure リージョン名（例: Sweden Central）"
  type        = string
}
