**Provision a new Azure Virtual Machine**

subId = "<subscription-ID>"

rgname   = "<Azure-RG-name>"

location = "<RG-location>"

resource_tags = <create-a-map>

```go
{
  "Application" = "visualtest"
  "Env"         = "test"
}
```
**Azure Virtual Network details**

vnetname   = "<VNET-name>"

vnetrgname = "<RG-name-for-VNET>"

subnetname = "<Subnet-name>"

**Azure VM details**

hostname       = "<VM-name>"

vmsize         = "<VM-size>"

localadmin     = "<local-admin>"

passwd         = "<password>"

license_type   = "<none/BYOL>"

```go
Preferred values are {None, RHEL_BASE, RHEL_BASESAPAPPS, RHEL_BASESAPHA, RHEL_BYOS, RHEL_ELS_6, RHEL_EUS, RHEL_SAPAPPS, RHEL_SAPHA, SLES, SLES_BYOS, SLES_HPC, SLES_SAP, SLES_STANDARD, Windows_Client, Windows_Server}
```

storageAccType = "Standard_LRS"

**Operating System details**

publisher = "MicrosoftWindowsServer"

offer     = "WindowsServer"

sku       = "2019-Datacenter"

vrsn      = "latest"

**VM datadisk details**

dataDiskSize = <data-disk-size>