data "azurerm_resource_group" "rg" {
  name = var.rgname
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.control_node}-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = var.vnet_address_space
}
resource "azurerm_subnet" "subnet" {
  name                 = "${var.control_node}-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

/*
data "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  resource_group_name = data.azurerm_resource_group.rg.name
}
data "azurerm_subnet" "subnet" {
  name                 = var.subnetname
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}
data "azurerm_public_ip" "ip" {
  name = ""
  resource_group_name = data.azurerm_resource_group.rg.name
}
*/
resource "azurerm_public_ip" "ip" {
  name                = "${var.control_node}-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  tags                = var.resource_tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.control_node}-nsg"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = var.resource_tags
}
resource "azurerm_network_security_rule" "nsg_rule" {
  count                       = length(var.nsg_rule_map)
  name                        = element(var.nsg_rule_name, count.index)
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = (100 + ("${count.index}" + 1))
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = lookup(var.nsg_rule_map, element(var.nsg_rule_name, count.index))
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.control_node}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
  tags = var.resource_tags
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "control_linux_vm" {
  name                  = var.control_node
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.vmsize
  admin_username        = var.localadmin
  admin_password        = var.passwd
  network_interface_ids = [azurerm_network_interface.nic.id]

  disable_password_authentication = false

  source_image_reference {
    publisher = lookup(var.control_vm_image_details, "publisher")
    offer     = lookup(var.control_vm_image_details, "offer")
    sku       = lookup(var.control_vm_image_details, "sku")
    version   = lookup(var.control_vm_image_details, "vrsn")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storageAccType
  }

  tags = var.resource_tags

  connection {
    type     = "ssh"
    user     = var.localadmin
    password = var.passwd
    host     = self.public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.passwd} | sudo -S yum install -y python",
      "sudo yum install -y ansible"
      /*
      "yum install -y python-pip",
      "pip install -y ansible"
      */
    ]

  }

}
