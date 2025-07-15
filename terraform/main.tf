# Azure のプロバイダーを指定します
# ここで使う Azure サブスクリプションIDを設定します
provider "azurerm" {
  features {} # 必須のブロック。空でもOK（細かい機能制御用）

  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # ★本番環境では完全なサブスクリプションIDを入力する必要があります
}

# --------------------------------------------
# ① リソースグループの作成
# Azure リソースをまとめて管理する「プロジェクトの箱」
# --------------------------------------------
module "resource_group" {
  source   = "./modules/resource_group" # モジュールの場所（相対パス）
  name     = "rg-ai-founder"            # リソースグループ名
  location = "Sweden Central"           # デプロイ先リージョン
}

# --------------------------------------------
# ② Key Vault の作成
# パスワードやAPIキーを安全に保存するサービス
# --------------------------------------------
module "key_vault" {
  source              = "./modules/key_vault"
  location            = module.resource_group.location # 作成したRGのリージョンを使用
  resource_group_name = module.resource_group.name     # 作成したRGの名前を使用
  key_vault_name      = "kv-ai-founder"                # Key Vault の名前
}

# --------------------------------------------
# ③ Container Registry の作成（ACR）
# コンテナイメージを保存・配信するためのAzureサービス
# --------------------------------------------
module "container_registry" {
  source              = "./modules/container_registry"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  key_vault_name      = module.key_vault.key_vault_name # Key Vault名を他モジュールに渡す
  name                = "acrfoundry0715"                # ACR名（グローバルで一意である必要あり）
}

# --------------------------------------------
# ④ Container App の作成
# コンテナアプリを動かすAzureサービス（FaaSに近い）
# --------------------------------------------
module "container_app" {
  source              = "./modules/container_app"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  key_vault_name      = module.key_vault.key_vault_name
  container_app_name  = "acr-foundry" # アプリの名前
}
