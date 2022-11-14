terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.30.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "hello008gr" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "newstorageforhello008" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_resource_group.hello008gr
  ]
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "app_service_plan"
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = "Windows"
  sku_name            = "Y1"


   depends_on = [
    azurerm_storage_account.newstorageforhello008
  ]
}

resource "azurerm_windows_function_app" "Hello008" {
  name                = "Hello008"
  resource_group_name = azurerm_resource_group.hello008gr.name
  location            = local.location

  storage_account_name       = local.storage_account_name
  storage_account_access_key = azurerm_storage_account.newstorageforhello008.primary_access_key
  service_plan_id            = azurerm_service_plan.app_service_plan.id 

  site_config {}
}