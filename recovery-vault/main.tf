terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.19.1"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subId
}

data "azurerm_resource_group" "rg" {
  name = var.rgname
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.vaultname
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = var.skutype
  tags                = data.azurerm_resource_group.rg.tags
}
resource "azurerm_backup_policy_vm" "policy" {
  name                           = "default"
  resource_group_name            = data.azurerm_resource_group.rg.name
  recovery_vault_name            = azurerm_recovery_services_vault.vault.name
  timezone                       = var.policy_timezone
  instant_restore_retention_days = 2

  backup {
    frequency = "Daily"
    time      = var.backup_time
  }

  retention_daily {
    count = var.daily_retention_days
  }

  retention_weekly {
    count    = var.weekly_retention_days
    weekdays = ["Sunday"]
  }
}
#Use this data block to access information about an existing Virtual Machine.
data "azurerm_virtual_machine" "vm" {
  name                = var.vmname
  resource_group_name = data.azurerm_resource_group.rg.name
}

#Enable backup for an Azure VM
resource "azurerm_backup_protected_vm" "name" {
  resource_group_name = data.azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = data.azurerm_virtual_machine.vm.id
  backup_policy_id    = azurerm_backup_policy_vm.policy.id
}