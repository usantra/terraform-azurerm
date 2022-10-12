
variable "subId" {
  description = "Please provide the Subscription ID"
  default     = null
}

variable "rgname" {
  description = "Provide the Resource Group name"
  type        = string
  default     = null
}

variable "location" {
  description = "Enter the region"
  type        = string
  default     = null
}

variable "resource_tags" {
  description = "Enter resource tags"
  type        = map(string)
}

variable "vnetname" {
  description = "Provide the Virtual Network name"
  type        = string
  default     = null
}
variable "vnetrgname" {
  description = "Virtual Network resource group name"
  type        = string
  default     = null
}

variable "subnetname" {
  description = "Provide the name of the Subnet"
  default     = null
}

variable "hostname" {
  description = "Please provide the VM hostname"
  default     = null
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

# license_type should be "Windows_Server" for Azure Hybrid Benefit and for PAYG it should be "None"
variable "license_type" {
  description = "Azure Hybrid Benefit for Windows status"
  type        = string
  default     = "None"
}

variable "storageAccType" {
  description = "Type the storage account type"
  type        = string
  default     = null
}

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

variable "dataDiskSize" {
  description = "VM datadisk size in GB"
  type        = number
  default     = null
}

variable "shutdown_timezone" {
  description = "Auto-shutdown timezone for the Azure VM"
  type        = string
  default     = null
}
variable "shutdown_time" {
  description = "Must match the format HHmm where HH is 00-23 and mm is 00-59 (e.g. 0930, 2300, etc.)"
  type        = number
  default     = null
}