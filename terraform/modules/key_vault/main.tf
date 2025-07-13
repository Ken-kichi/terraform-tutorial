# 現在ログインしているAzureのクライアント情報（テナントIDなど）を取得します
# Key Vaultの作成にはこのテナントIDが必要になります
data "azurerm_client_config" "current" {}

# Azure Key Vault を作成します
# Key Vault はパスワードやAPIキー、証明書などの機密情報を安全に保管できるサービスです
resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name             # Key Vault の名前（グローバルで一意にする必要があります）
  location            = var.location                   # 配置する Azure リージョン（例: Sweden Central）
  resource_group_name = var.resource_group_name        # 所属するリソースグループの名前
  tenant_id           = data.azurerm_client_config.current.tenant_id  # このKey Vaultを管理するAzureテナントのID

  sku_name            = "standard"                     # 利用する料金プラン（standardでOK）

  purge_protection_enabled = true                      # 削除保護を有効にする（削除後も一定期間復元できる）
}
