provider "azurerm" {
features {}
}

resource "azurerm_virtual_network" "vnet" {
name                = "udacity-vnet"
location            = var.location
resource_group_name = var.resource_group_name
address_space       = ["10.0.0.0/16"]

tags = var.tags
}

resource "azurerm_subnet" "subnet" {
name                 = "udacity-subnet"
resource_group_name  = var.resource_group_name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
name                = "udacity-nsg"
location            = var.location
resource_group_name = var.resource_group_name

tags = var.tags
}

resource "azurerm_public_ip" "lb_ip" {
name                = "udacity-public-ip"
location            = var.location
resource_group_name = var.resource_group_name
allocation_method   = "Static"

tags = var.tags
}

resource "azurerm_lb" "lb" {
name                = "udacity-lb"
location            = var.location
resource_group_name = var.resource_group_name

frontend_ip_configuration {
name                 = "PublicIPAddress"
public_ip_address_id = azurerm_public_ip.lb_ip.id
}

tags = var.tags
}

resource "azurerm_availability_set" "avset" {
name                         = "udacity-avset"
location                     = var.location
resource_group_name          = var.resource_group_name
platform_fault_domain_count  = 2
platform_update_domain_count = 2

tags = var.tags
}

resource "azurerm_network_interface" "nic" {
count               = var.vm_count
name                = "udacity-nic-${count.index}"
location            = var.location
resource_group_name = var.resource_group_name

ip_configuration {
name                          = "internal"
subnet_id                     = azurerm_subnet.subnet.id
private_ip_address_allocation = "Dynamic"
}

tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
count               = var.vm_count
name                = "udacity-vm-${count.index}"
resource_group_name = var.resource_group_name
location            = var.location
size                = "Standard_B1s"
admin_username      = var.admin_username

network_interface_ids = [
azurerm_network_interface.nic[count.index].id
]

admin_ssh_key {
username   = var.admin_username
public_key = file("~/.ssh/id_rsa.pub")
}

source_image_id = var.image_id

os_disk {
caching              = "ReadWrite"
storage_account_type = "Standard_LRS"
}

availability_set_id = azurerm_availability_set.avset.id

tags = var.tags
}
