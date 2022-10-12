terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "3.19.1"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "5238c077-40d5-4715-9e4f-d52c5f51f555"
}

data "azurerm_resource_group" "test" {
  name = "azuredemogrp1"
}

resource "azurerm_virtual_network" "vnet" {
  name                = lower("${var.vnetname}-production")
  resource_group_name = data.azurerm_resource_group.test.name
  location            = data.azurerm_resource_group.test.location
  address_space       = ["10.0.0.0/16", "20.0.0.0/24"]
  tags                = data.azurerm_resource_group.test.tags
}

resource "azurerm_subnet" "test" {
  name                 = "terraform_internal"
  resource_group_name  = data.azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

output "VNET_name" {
  value = azurerm_virtual_network.vnet.name
}
output "subnet_name" {
  value = azurerm_subnet.test.name
}