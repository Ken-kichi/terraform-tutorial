# 現在ログインしているAzureのクライアント情報を取得します
# tenant_id: テナントID（Azure Active DirectoryのID）
# object_id: Terraform実行者のユーザーまたはサービスプリンシパルのObject ID
data "azurerm_client_config" "current" {}

# Azure Key Vault を作成します
# Key Vault は、APIキー・パスワード・証明書などの機密情報を安全に保管・管理できるサービスです
resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name                           # Key Vault の名前（Azure全体で一意である必要があります）
  location            = var.location                                 # デプロイ先のAzureリージョン（例: "Sweden Central"）
  resource_group_name = var.resource_group_name                      # Key Vaultを配置するリソースグループ名
  tenant_id           = data.azurerm_client_config.current.tenant_id # 管理対象となるAzure ADテナントID

  sku_name = "standard" # Key Vaultの料金プラン（"standard" または "premium"）

  purge_protection_enabled = true # Key Vault削除後の復元を可能にする（安全性を高める）

  # Key Vaultに対するアクセス権限を設定します（Terraform実行者に付与）
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id # 対象テナント
    object_id = data.azurerm_client_config.current.object_id # Terraform実行者のObject ID

    # シークレットに対する許可（APIキーやパスワードの取得・設定など）
    secret_permissions = [
      "Get",    # シークレットの取得
      "Set",    # シークレットの作成・更新
      "Delete", # シークレットの削除
      "List"    # シークレットの一覧取得
    ]

    # 鍵に対する許可（暗号化・署名などに利用）
    key_permissions = [
      "Get",    # 鍵の取得
      "List",   # 鍵の一覧取得
      "Update", # 鍵の更新
      "Create"  # 鍵の作成
    ]
  }
}
