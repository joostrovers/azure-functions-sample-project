provider "azurerm" {
  tenant_id       = var.AZURE_TENANT_ID
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_CLIENT_SECRET

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
