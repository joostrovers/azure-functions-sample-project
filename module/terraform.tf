terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.12.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.1.0"
    }
  }
}
