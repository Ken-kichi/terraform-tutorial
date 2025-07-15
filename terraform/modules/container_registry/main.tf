# Azure Container Registry（ACR）を作成します
# ACRは、Dockerイメージを保存しておくAzure上のプライベートレジストリです
# Container App や他のサービスがここからイメージを取得できます

resource "azurerm_container_registry" "this" {
  name                = var.name                # ACRの名前（グローバルで一意にする必要あり。例: acrfoundry123）
  location            = var.location            # デプロイ先のAzureリージョン（例: Sweden Central）
  resource_group_name = var.resource_group_name # 紐づけるリソースグループ名

  sku           = "Basic" # 利用する料金プラン（Basic, Standard, Premium から選択可能）
  admin_enabled = true    # 管理者ユーザー（adminユーザー名とパスワード）を有効にする（開発・検証向け）
}
