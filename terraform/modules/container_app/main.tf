# Container App の実行環境（バックエンド基盤）を作成します
# これは実際のアプリを置く「家の土地」のようなものです
resource "azurerm_container_app_environment" "this" {
  name                = var.container_app_name  # 環境の名前（通常はアプリ名と一致させてもOK）
  location            = var.location            # リージョン（例：Sweden Central）
  resource_group_name = var.resource_group_name # リソースグループ名
}

# 実際の Container App を作成します（アプリの本体）
resource "azurerm_container_app" "this" {
  name                         = var.container_app_name                    # アプリ名
  container_app_environment_id = azurerm_container_app_environment.this.id # どの環境に作るか（上で作った環境）

  resource_group_name = var.resource_group_name # リソースグループ名

  revision_mode = "Single" # バージョンを1つだけ保持（デプロイ時の履歴管理の設定）

  # アプリで動かすコンテナの設定（中身の定義）
  template {
    container {
      name   = "app"                                                         # コンテナの名前（好きな名前でOK）
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest" # 使用するDockerイメージ
      cpu    = 0.5                                                           # 割り当てるCPU（0.5 = 約0.5コア）
      memory = "1Gi"                                                         # メモリサイズ（1GB）
    }
  }

  # 外部アクセスの設定（インターネットからアクセスできるようにする）
  ingress {
    external_enabled = true   # 外部公開を有効にする
    target_port      = 80     # Webアプリが待ち受けるポート（通常80や3000など）
    transport        = "auto" # 通信方式は自動（http/https）

    # トラフィックの配分（今回は常に最新版に100%送る）
    traffic_weight {
      percentage      = 100  # 100%この設定に流す
      latest_revision = true # 最新のリビジョンに流す
    }
  }
}
