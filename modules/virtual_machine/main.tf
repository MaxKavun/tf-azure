
/*resource "azurerm_public_ip" "pub1" { # moved to load balancer
  name                = "pub1"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}*/

resource "azurerm_network_interface" "vm1" {
  name                = "nicvm1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.pub1.id # moved to load balancer 
  }
}

data "template_file" "webapp" {
  template = file("${path.module}/setup.tpl")
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1ms"
  admin_username      = "adminuser"

  custom_data = base64encode(data.template_file.webapp.rendered)
  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
