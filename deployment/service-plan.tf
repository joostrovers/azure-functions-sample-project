######################
# App Service Plan
######################

resource "azurerm_service_plan" "service_plan" {
  name                = var.prefix
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "EP1"

  maximum_elastic_worker_count = 20
}
