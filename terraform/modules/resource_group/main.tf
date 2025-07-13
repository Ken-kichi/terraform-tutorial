# Azure のリソースグループを作成します
# リソースグループとは、Azure上の複数のリソース（VM、DB、Appなど）をまとめて管理する「フォルダ」のようなものです
resource "azurerm_resource_group" "this" {
  name     = var.name       # リソースグループの名前（例: "rg-myproject"）
  location = var.location   # Azureリージョン（例: "Sweden Central"）
}

# リソースグループの名前を外部（他のモジュールなど）に出力します
# 他のモジュールで module.resource_group.name のように使えるようになります
output "name" {
  value = azurerm_resource_group.this.name
}

# リソースグループのリージョン（場所）も出力します
# 他のリソースと同じ場所にデプロイするために再利用できます
output "location" {
  value = azurerm_resource_group.this.location
}
