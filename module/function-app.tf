locals {
  function_app_zip_file = "${path.module}/function-app.zip"
  function_app_name     = format("%.32s", replace("${var.prefix}${var.resource_group.location}", "/[^a-z0-9]+/", ""))
  service_fqdn          = "${local.function_app_name}.azurewebsites.net"
  service_url           = "https://${local.service_fqdn}"
  auth_type             = "McmaApiKey"

  storage_container_url = var.use_flex_consumption_plan ? "${var.storage_account.primary_blob_endpoint}${azurerm_storage_container.function_app[0].name}" : ""
}

resource "local_sensitive_file" "function_app" {
  filename = ".terraform/${filesha256(local.function_app_zip_file)}.zip"
  source   = local.function_app_zip_file
}

resource "azurerm_storage_container" "function_app" {
  count = var.use_flex_consumption_plan ? 1 : 0

  name                  = var.prefix
  storage_account_id    = var.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "function_app" {
  count = var.use_flex_consumption_plan ? 1 : 0

  name                   = "released-package.zip"
  storage_account_name   = var.storage_account.name
  storage_container_name = azurerm_storage_container.function_app[0].name
  type                   = "Block"
  source                 = local_sensitive_file.function_app.filename
}

resource "azapi_resource" "function_app" {
  count = var.use_flex_consumption_plan ? 1 : 0

  depends_on = [
    local_sensitive_file.function_app
  ]

  type      = "Microsoft.Web/sites@2024-04-01"
  location  = var.resource_group.location
  name      = local.function_app_name
  parent_id = var.resource_group.id
  body = {
    kind = "functionapp,linux"
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      functionAppConfig = {
        deployment = {
          storage = {
            type  = "blobcontainer"
            value = local.storage_container_url
            authentication = {
              type = "systemassignedidentity"
            }
          }
        }
        runtime = {
          name    = "node"
          version = "20"
        }
        scaleAndConcurrency = {
          alwaysReady = [
            # {
            #   name          = "function:queue-handler"
            #   instanceCount = 1
            # }
          ]
          instanceMemoryMB     = 2048
          maximumInstanceCount = 100
        }
      }
      httpsOnly    = true
      serverFarmId = local.service_plan_id
      siteConfig = {
        appSettings = [
          {
            name  = "AzureWebJobsStorage"
            value = var.storage_account.primary_connection_string
          },
          {
            name  = "FUNCTION_CODE_HASH"
            value = filesha256(local.function_app_zip_file)
          },
          {
            name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
            value = var.app_insights.connection_string
          },
          {
            name  = "MCMA_PUBLIC_URL",
            value = local.service_url
          },
          {
            name  = "MCMA_COSMOS_DB_REGION",
            value = var.resource_group.location
          },
          {
            name  = "QUEUE_NAME",
            value = azurerm_storage_queue.queue.name
          },
          {
            name  = "QUEUE_URL",
            value = azurerm_storage_queue.queue.id
          },
          {
            name  = "AzureFunctionsJobHost__extensions__queues__batchSize",
            value = "1"
          },
        ]
      }
    }
  }
}

resource "azurerm_role_assignment" "function_app" {
  count = var.use_flex_consumption_plan ? 1 : 0

  scope                = var.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azapi_resource.function_app[0].output.identity.principalId
}

resource "azurerm_windows_function_app" "function_app" {
  count = var.use_flex_consumption_plan ? 0 : 1

  name                = local.function_app_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  storage_account_name       = var.storage_account.name
  storage_account_access_key = var.storage_account.primary_access_key
  service_plan_id            = local.service_plan_id

  builtin_logging_enabled = false

  site_config {
    application_stack {
      node_version = "~20"
    }

    elastic_instance_minimum               = var.function_elastic_instance_minimum
    application_insights_connection_string = var.app_insights.connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  https_only      = true
  zip_deploy_file = local_sensitive_file.function_app.filename

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"

    MCMA_PUBLIC_URL = local.service_url

    QUEUE_NAME = azurerm_storage_queue.queue.name
    QUEUE_URL  = azurerm_storage_queue.queue.id

    AzureFunctionsJobHost__functionTimeout = var.worker_function_timeout != null ? var.worker_function_timeout : var.use_flex_consumption_plan ? "01:00:00" : "00:10:00"
  }

  tags = var.tags
}

resource "azurerm_storage_queue" "queue" {
  name                 = var.prefix
  storage_account_name = var.storage_account.name
}

resource "azurerm_role_assignment" "queue" {
  scope                = azurerm_storage_queue.queue.resource_manager_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.use_flex_consumption_plan ? azapi_resource.function_app[0].output.identity.principalId : azurerm_windows_function_app.function_app[0].identity[0].principal_id
}
