variable "subId" {
  description = "Subscription ID"
  type        = string
  default     = null
}

variable "rgname" {
  description = "Resource Group name"
  type        = string
  default     = null
}

variable "rglocation" {
  description = "Resource Group region"
  type        = string
  default     = null
}

variable "storage_name" {
  description = "Storage Account name"
  type        = string
  default     = null
  validation {
    condition     = length(var.storage_name) >= 3 && length(var.storage_name) <= 24
    error_message = "The field can contain only lowercase letters and numbers. Name must be between 3 and 24 characters."
  }
}

# Supported values are "Standard" and "Premium"
variable "account_tier" {
  description = "Define storage account tier"
  type        = string
  default     = "Standard"
}
# Supported values are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2
variable "account_kind" {
  description = "Define the storage account kind"
  type        = string
  default     = "StorageV2"
}
# Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS
variable "replication_type" {
  description = "Account replication type"
  type        = string
  default     = "LRS"
}
# Supported values are "Hot" and "Cool"
variable "access_tier" {
  description = "Access tier for the storage account"
  type        = string
  default     = "Hot"
}

variable "containers_count" {
  description = "Storage containers"
  type        = number
  default     = 0
}

variable "resource_tags" {
  description = "Resource tags"
  type        = map(string)
}