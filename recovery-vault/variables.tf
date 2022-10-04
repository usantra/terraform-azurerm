variable "subId" {
  description = "Provide Azure Subscription ID"
  type        = string
  default     = null
}
variable "rgname" {
  description = "Resource group name"
  type        = string
  default     = null
}

variable "vaultname" {
  description = "Recovery Services Vault name"
  type        = string
  default     = null
}
variable "skutype" {
  description = "Vault SKU type"
  type        = string
  default     = null
}
variable "policy_timezone" {
  description = "Timezone for the backup policy"
  type        = string
  default     = null
}
variable "backup_time" {
  description = "Backup execution time in 24 hours format"
  type        = string
  default     = null
}
variable "daily_retention_days" {
  description = "Daily backup retention days"
  type        = number
  default     = null
}
variable "weekly_retention_days" {
  description = "Weekly backup retention days"
  type        = number
  default     = null
}
variable "vmname" {
  description = "Virtual Machine hostname"
  type        = string
  default     = null
}
