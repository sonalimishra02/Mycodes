resource "azurerm_resource_group" "terraform-lab" {
  name     = "terraform-lab"
  location = "West Europe"
}

resource "azurerm_virtual_network" "lab-network" {
  name                = "lab-network"
  resource_group_name = azurerm_resource_group.terraform-lab.name
  location            = azurerm_resource_group.terraform-lab.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    env = "prod"
  }
}

resource "azurerm_subnet" "lab-subnet" {
  name                 = "lab-subnet"
  resource_group_name  = azurerm_resource_group.terraform-lab.name
  virtual_network_name = azurerm_virtual_network.lab-network.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_network_interface" "lab-VNI" {
  name                = "lab-VNI"
  resource_group_name = azurerm_resource_group.terraform-lab.name
  location            = azurerm_resource_group.terraform-lab.location

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.lab-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "lab-VM" {
  name                  = "lab-VM"
  location              = azurerm_resource_group.terraform-lab.location
  resource_group_name   = azurerm_resource_group.terraform-lab.name
  size                  = "Standard_F2"
  admin_username        = "sonali"
  admin_password        = "Sonali@2597"
  network_interface_ids = [
    azurerm_network_interface.lab-VNI.id,
    ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    Name = "VM1"
    Env  = "prod"
  }

}

