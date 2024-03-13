resource "azurerm_resource_group" "rgp" {
  name     = var.rgp_name
  location = var.rgp_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.1.0.0/24"]
  location            = azurerm_resource_group.rgp.location
  resource_group_name = azurerm_resource_group.rgp.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.snet_name
  resource_group_name  = azurerm_resource_group.rgp.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  location            = azurerm_resource_group.rgp.location
  resource_group_name = azurerm_resource_group.rgp.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rgp.location
  resource_group_name = azurerm_resource_group.rgp.name

  security_rule {
    name                       = "AllowJenkins"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSsh"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = azurerm_resource_group.rgp.name
  location            = azurerm_resource_group.rgp.location

  ip_configuration {
    name                          = "nic-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.rgp.name
  location                        = azurerm_resource_group.rgp.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "osdisk-${var.vm_name}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
