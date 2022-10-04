variable "subId" {
  description = "Please provide the Subscription ID"
  default     = null
}

variable "rgname" {
  description = "Provide the Resource Group name"
  type        = string
  default     = null
}

variable "hostname" {
  description = "Please provide the VM hostname"
  default     = null
}

variable "storageAccType" {
  description = "Type the storage account type"
  type        = string
  default     = null
}
variable "dataDiskSize" {
  description = "VM datadisk size in GB"
  type        = number
  default     = null
}