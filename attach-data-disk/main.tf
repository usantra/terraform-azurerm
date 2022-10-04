terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subId
}

data "azurerm_resource_group" "rg" {
  name = var.rgname
}

data "azurerm_virtual_machine" "vm" {
  name                = var.hostname
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_managed_disk" "newdisk" {
  name                 = lower("${var.hostname}_datadisk_${count.index + 1}")
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = var.storageAccType
  create_option        = "Empty"
  disk_size_gb         = var.dataDiskSize
  count                = 1
}

resource "azurerm_virtual_machine_data_disk_attachment" "diskattach" {
  managed_disk_id    = azurerm_managed_disk.newdisk[count.index].id
  virtual_machine_id = data.azurerm_virtual_machine.vm.id
  lun                = count.index + 1
  caching            = "ReadWrite"
  count              = 1
}
