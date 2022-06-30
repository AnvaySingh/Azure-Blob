terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=0.1.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "######"
}

provider "azapi" {
  skip_provider_registration = true
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = "Canada Central"
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "this" {
  name                  = var.storage_container
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azapi_update_resource" "this" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2021-08-01"
  name      = "default"
  parent_id = azurerm_storage_container.this.resource_manager_id

  body = jsonencode({
    properties = {
      allowProtectedAppendWrites            = false
      # allowProtectedAppendWritesAll         = null
      immutabilityPeriodSinceCreationInDays = 30
    }
  })
  response_export_values = ["etag"]
}
