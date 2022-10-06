**Create Recovery Services Vault along with its policy for existing Azure VM**

subId    = "<subscriptionID>"

rgname   = "<Resource-group-name>"

location = "<azure-region>"

vaultname             = "<Recovery-vault-name>"

skutype               = "Standard"

policy_timezone       = "<time-zone>"

backup_time           = "<time>"

daily_retention_days  = <retention-period>

weekly_retention_days = <retention-period>

vmname                = "<vm-hostname>"