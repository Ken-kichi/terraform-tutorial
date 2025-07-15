# このモジュールから "key_vault_name" という名前で Key Vault の名前を出力します
# これにより、他のモジュールや root モジュールで参照できるようになります

output "key_vault_name" {
  value = azurerm_key_vault.this.name # 作成された Key Vault の名前（リソースIDではなく名前そのもの）
}
