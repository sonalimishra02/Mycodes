data "azurerm_resource_group" "rg-existing" {
  name = "terraform-lab"
}

data "azurerm_virtual_network" "VN-existing" {
    name = "lab-network"
    resource_group_name = data.azurerm_resource_group.rg-existing.name

}

data "azurerm_subnet" "subnet-existing" {
    name = "lab-subnet"
    resource_group_name = data.azurerm_resource_group.rg-existing.name
    virtual_network_name = data.azurerm_virtual_network.VN-existing.name

}

resource "azurerm_network_interface" "lab-VNI1" {
  name                = "lab-VNI1"
  resource_group_name = data.azurerm_resource_group.rg-existing.name
  location            = data.azurerm_resource_group.rg-existing.location

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = data.azurerm_subnet.subnet-existing.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "lab-VM1" {
  name                  = "lab-VM1"
  location              = data.azurerm_resource_group.rg-existing.location
  resource_group_name   = data.azurerm_resource_group.rg-existing.name
  size                  = "Standard_F2"
  admin_username        = "sonali"
  admin_password        = "Sonali@2597"
  network_interface_ids = [
    azurerm_network_interface.lab-VNI1.id,
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
    Name = "VM2"
    Env  = "dev"
  }

}