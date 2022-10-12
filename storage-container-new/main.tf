terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subId
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.rglocation
}

resource "azurerm_storage_account" "storage_account" {
  name                = var.storage_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = var.account_tier
  account_kind             = var.account_kind
  account_replication_type = var.replication_type
  access_tier              = var.access_tier

  tags = var.resource_tags
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.storage_name}-container-${count.index}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
  count                 = var.containers_count
}