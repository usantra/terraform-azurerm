terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.19.1"
    }
  }
}
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
  }
  subscription_id = var.subId
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
  tags     = var.resource_tags
}
data "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  resource_group_name = var.vnetrgname
}
data "azurerm_subnet" "subnet" {
  name                 = var.subnetname
  resource_group_name  = var.vnetrgname
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}
resource "azurerm_public_ip" "ip" {
  name                = "${var.hostname}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  tags                = var.resource_tags
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.hostname}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
  tags = var.resource_tags
}
resource "azurerm_windows_virtual_machine" "winvm" {
  name                  = var.hostname
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vmsize
  admin_username        = var.localadmin
  admin_password        = var.passwd
  network_interface_ids = [azurerm_network_interface.nic.id]
  license_type          = var.license_type

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storageAccType
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.vrsn
  }
  tags = var.resource_tags
}
resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.hostname}-datadisk-${count.index}"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_type = var.storageAccType
  create_option        = "Empty"
  disk_size_gb         = var.dataDiskSize
  count                = 1
  tags                 = var.resource_tags
}

#Using splat expression
resource "azurerm_virtual_machine_data_disk_attachment" "diskattach" {
  managed_disk_id    = azurerm_managed_disk.datadisk[*].id
  virtual_machine_id = azurerm_windows_virtual_machine.winvm.id
  lun                = count.index
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "diskattach" {
  managed_disk_id    = azurerm_managed_disk.datadisk[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.winvm.id
  lun                = count.index
  caching            = "ReadWrite"
  count              = 1
}