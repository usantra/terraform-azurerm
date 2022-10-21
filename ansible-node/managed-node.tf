/*
data "azurerm_resource_group" "rg" {
  name = var.rgname
}
*/

resource "azurerm_subnet" "managed_subnet" {
  name                 = "managed-node-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_network_security_group" "managed_nsg" {
  name                = "managed_node-nsg"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = var.managed_resource_tag
}
resource "azurerm_network_security_rule" "managed_nsg_rule" {
  count                       = length(var.nsg_rule_map)
  name                        = element(var.nsg_rule_name, count.index)
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.managed_nsg.name
  priority                    = (100 + ("${count.index}" + 1))
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = lookup(var.nsg_rule_map, element(var.nsg_rule_name, count.index))
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "name" {
  subnet_id                 = azurerm_subnet.managed_subnet.id
  network_security_group_id = azurerm_network_security_group.managed_nsg.id
}

resource "azurerm_public_ip" "managed_ip" {
  count               = length(var.managed_node)
  name                = element(var.managed_node, count.index)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  tags                = var.managed_resource_tag
}

resource "azurerm_network_interface" "managed_nic" {
  count               = length(var.managed_node)
  name                = format("%s-nic", element(var.managed_node, count.index))
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = element(azurerm_subnet.managed_subnet[*].id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.ip[*].id, count.index)
  }
  tags = var.managed_resource_tag
}

resource "azurerm_linux_virtual_machine" "managed_linux_vm" {
  count                 = length(var.managed_node)
  name                  = element(var.managed_node, count.index)
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.vmsize
  admin_username        = var.localadmin
  admin_password        = var.passwd
  network_interface_ids = element(chunklist(azurerm_network_interface.managed_nic[*].id, 1), count.index)

  disable_password_authentication = false

  source_image_reference {
    publisher = lookup(var.managed_vm_image_details, "publisher")
    offer     = lookup(var.managed_vm_image_details, "offer")
    sku       = lookup(var.managed_vm_image_details, "sku")
    version   = lookup(var.managed_vm_image_details, "vrsn")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storageAccType
  }

  tags = var.managed_resource_tag

}

