//Nombre del grupo de recursos
variable "resource_group_name" {
  description = "Nombre del Resource Group existente en Azure"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }
}

variable "storage_account_name" {
  description = "Nombre de la cuenta de almacenamiento existente en Azure"
  type        = string
  default = "sta1plopez"
}

//Nombre de la red virtual 
variable "vnet_name" {

  description = "Nombre de la VNet"
  type        = string
  validation {
    condition     = length(var.vnet_name) > 0 && can(regex("^vnet[a-z]{2,}tfexercise\\d{2,}$", var.vnet_name))
    error_message = "vnet_name no puede estar vacío debe comenzar con 'vnet', seguido de al menos dos caracteres en el rango [a-z], seguido de 'tfexercise', y terminar con al menos dos dígitos numéricos."
  }
}

// Espacio de direcciones de la red virtual
variable "vnet_address_space" {
  description = "Espacio de direcciones de la Virtual Network"
  type        = list(string)
  validation {
    condition     = can(cidrsubnet(element(var.vnet_address_space, 0), 0, 0))
    error_message = "The VNet address space must be a valid CIDR block."
  }
}

variable "location" {
  description = "Ubicación donde se desplegará la VNet"
  default     = "West Europe"
}


variable "subnets" {
    description = "Subredes de la VNet"
    type = map(object({
        name                 = string
        resource_group_name  = string
        virtual_network_name = string
        address_prefixes     = list(string)
    }))
  
}

# variable "subnet2" {
#     description = "Subredes de la VNet"
#     type = map(object({
#         name                 = string
#         resource_group_name  = string
#         virtual_network_name = string
#         address_prefixes     = list(string)
#     }))
  
# }

# Network Interface
variable "network_interface" {
  description = "The network interface configuration"
  type = map(object({
    ip_configuration = object({
      name                          = string
      private_ip_address_allocation = string
      public_ip_address_id          = optional(string)
    })
  }))
}



# Máquinas virtuales Linux
variable "linux_virtual_machine" {
    description = "Máquinas virtuales Linux"
    type        = map(object({
        computer_name       = string
        name                = string
        resource_group_name = string
        location            = string
        size                = string
        admin_username      = string
        admin_password      = string
        os_disk = object({
            caching              = string
            storage_account_type = string
        })
        source_image_reference = object({
            publisher = string
            offer     = string
            sku       = string
            version   = string
        })
    }))

    default = {
        "linux_vm1" = {
            computer_name       = "Linux1"
            name                = "linux_vm1"
            resource_group_name = "rg1plopez-lab01"
            location            = "West Europe"
            size                = "Standard_F2"
            admin_username      = "adminuser"
            admin_password      = "A1b#c2"
            os_disk = {
                caching              = "ReadWrite"
                storage_account_type = "Standard_LRS"
            }
            source_image_reference = {
                publisher = "Canonical"
                offer     = "0001-com-ubuntu-server-jammy"
                sku       = "22_04-lts"
                version   = "latest"
            }
        }
    }
  
}

variable "load_balancer" {
  description = "Load Balancer"
  type = object({
    name                 = string
    sku                  = string
    resource_group_name  = string
    location             = string
    frontend_ip_configuration = object({
      name                           = string
      private_ip_address_allocation  = string
      public_ip_address_id           = string
    })
    backend_address_pool = object({
      name = string
      load_balancer_id = string
    })
  })
}