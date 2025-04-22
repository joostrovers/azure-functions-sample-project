######################
# Providers
######################

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

provider "azapi" {
  tenant_id       = var.AZURE_TENANT_ID
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_CLIENT_SECRET
}

######################
# Modules
######################

module "function_app_consumption_plan" {
  source = "../module"

  prefix = "${var.prefix}-cp"

  use_flex_consumption_plan = false

  resource_group  = azurerm_resource_group.resource_group
  storage_account = azurerm_storage_account.storage_account_cp
  app_insights    = azurerm_application_insights.app_insights
}

module "function_app_flex_consumption_plan" {
  source = "../module"

  prefix = "${var.prefix}-fcp"

  use_flex_consumption_plan = true

  resource_group  = azurerm_resource_group.resource_group
  storage_account = azurerm_storage_account.storage_account_fcp
  app_insights    = azurerm_application_insights.app_insights
}
