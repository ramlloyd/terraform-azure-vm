provider "azurerm" {
  features {}
  subscription_id = "baca3462-6e15-428a-9161-cb78d5a78fc2"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tf"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-tf"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


resource "azurerm_network_security_group" "nsg" {
  name = "nsg-tf"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

security_rule {
  name                       = "allow-http"
  priority                   = 100
  access                     = "Allow"
  direction                  = "Inbound"
  protocol = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}
}
  
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-tf"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = "Standard_B1s"
  admin_username                  = "azure"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azure"
    public_key = file("C:/Users/Dell/.ssh/id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
