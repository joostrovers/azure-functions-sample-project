locals {
  api_handler1_zip_file      = "${path.module}/../functions/api-handler1/build/dist/function.zip"
  api_handler1_function_name = format("%.32s", replace("${var.prefix}api1${azurerm_resource_group.resource_group.location}", "/[^a-z0-9]+/", ""))
}

resource "local_sensitive_file" "api_handler1" {
  filename = ".terraform/${filesha256(local.api_handler1_zip_file)}.zip"
  source   = local.api_handler1_zip_file
}

resource "azurerm_windows_function_app" "api_handler1" {
  name                = local.api_handler1_function_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id

  builtin_logging_enabled = false

  site_config {
    application_stack {
      node_version = "~18"
    }

    application_insights_connection_string = azurerm_application_insights.app_insights.connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  https_only      = true
  zip_deploy_file = local_sensitive_file.api_handler1.filename

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}
