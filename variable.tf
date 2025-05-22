variable "subscription_id" {
    description = "subscription id for azure"
    type = string
    default = "baca3462-6e15-428a-9161-cb78d5a78fc2"
}
variable "resource_group" {
    description = "resource group for azure vm"
    type = string
    default = "rg-tf" 
}
variable "location" {
    type = string
    default = "East Us"
}

variable "vnet" {
    type = string
    default = "vnet-tf"
}
variable "address_space" {
    type = list(string)
  default = ["10.1.0.0/16"]
}
variable "subnet" {
    type = string
    default = "subnet-tf"
}

variable  "address_prefixes" {
    type = list(string)
    default = ["10.1.0.0/24"]
}
variable "public_ip" {
    type = string
    default = "vm-public-ip"
}
variable "priority" {
    type = number
    default = 100
}
variable "nic" {
    type = string
    default = "nic-tf"
}
variable "nsg" {
    type = string
    default = "nsg-tf"
}

variable "vm" {
  type = string
  default = "vm-tf"
}
variable "size" {
    type = string
    default = "Standard_B1s"  
}   
variable "username" {
    type = string
    default = "azure"
}

variable "storage_account_type" {
    type = string
    default = "Standard_LRS"
}

