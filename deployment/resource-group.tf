######################
# Resource Group
######################

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-${var.azure_location}"
  location = var.azure_location

  tags = fileexists("${path.module}/tags.json") ? jsondecode(file("${path.module}/tags.json")) : {}
}
