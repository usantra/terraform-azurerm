
variable "subId" {
  description = "Please provide the Subscription ID"
  default     = null
}

variable "rgname" {
  description = "Provide the Resource Group name"
  type        = string
  default     = null
}

variable "resource_tags" {
  description = "Enter resource tags for control_node"
  type        = map(string)
}
variable "managed_resource_tag" {
  description = "Enter resource tags for managed_node"
  type        = map(string)
}

/*
variable "vnetname" {
  description = "Provide the Virtual Network name"
  type        = string
  default     = null
}
variable "subnetname" {
  description = "Provide the name of the Subnet"
  default     = null
}
*/

variable "vnet_address_space" {
  description = "Address space list for the VNET"
  type        = list(string)
  default     = null
}
variable "subnet_address_prefix" {
  description = "Address prefix list for the subnet"
  type        = list(string)
  default     = null
}

variable "nsg_rule_name" {
  description = "NSG rule protocol list"
  type        = list(string)
  default     = null
}

variable "nsg_rule_map" {
  description = "Protocol and port number for NSG rule"
  type        = map(any)
  default     = {}
}

variable "control_node" {
  description = "Ansible control node hostname"
  default     = null
}
variable "managed_node" {
  description = "Ansible control node hostname"
  type        = list(string)
  default     = []
}


variable "vmsize" {
  description = "Please type the size of the VM"
  type        = string
  default     = null
}

variable "localadmin" {
  description = "Admin Username"
  type        = string
  sensitive   = false
  default     = null
}

variable "passwd" {
  description = "Admin password"
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = length(var.passwd) >= 12 && length(var.passwd) <= 32
    error_message = "Password length must be between 12 to 32"
  }
}

variable "storageAccType" {
  description = "Type the storage account type"
  type        = string
  default     = null
}
/*
variable "publisher" {
  description = "Provide the publisher of the OS"
  type        = string
  default     = null
}

variable "offer" {
  description = "Provide the offer name"
  type        = string
  default     = null
}

variable "sku" {
  description = "Provide OS sku"
  type        = string
  default     = null
}

variable "vrsn" {
  description = "OS version details"
  type        = string
  default     = null
}
*/
variable "control_vm_image_details" {
  description = "OS details for the control VM"
  type        = map(string)
  default     = {}
}
variable "managed_vm_image_details" {
  description = "OS details for the managed VM"
  type        = map(string)
  default     = {}
}