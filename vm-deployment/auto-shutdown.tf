resource "azurerm_dev_test_global_vm_shutdown_schedule" "name" {
  virtual_machine_id = azurerm_windows_virtual_machine.winvm.id
  location           = azurerm_resource_group.rg.location
  enabled            = true

  timezone              = var.shutdown_timezone
  daily_recurrence_time = var.shutdown_time

  notification_settings {
    enabled = false
  }
}