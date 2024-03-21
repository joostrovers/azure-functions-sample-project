locals {
  queue_consumer2_zip_file      = "${path.module}/../functions/queue-consumer2/build/dist/function.zip"
  queue_consumer2_function_name = format("%.32s", replace("${var.prefix}queueconsumer2${azurerm_resource_group.resource_group.location}", "/[^a-z0-9]+/", ""))
}

resource "local_sensitive_file" "queue_consumer2" {
  filename = ".terraform/${filesha256(local.queue_consumer2_zip_file)}.zip"
  source   = local.queue_consumer2_zip_file
}

resource "azurerm_windows_function_app" "queue_consumer2" {
  name                = local.queue_consumer2_function_name
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
  zip_deploy_file = local_sensitive_file.queue_consumer2.filename

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}

resource "azurerm_storage_queue" "queue2" {
  name                 = "queue2"
  storage_account_name = azurerm_storage_account.storage_account.name
}

resource "azurerm_role_assignment" "queue_contributor2" {
  scope                = azurerm_storage_queue.queue2.resource_manager_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_windows_function_app.queue_consumer2.identity[0].principal_id
}
