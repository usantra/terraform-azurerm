**Manages a Container within an Azure Storage Account**


storage_name => "This field can contain only lowercase letters and numbers. Name must be between 3 and 24 characters."

"account_tier" => Supported values are "Standard" and "Premium"

"account_kind" => Supported values are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2

"account_replication_type" => Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS

"access_tier" => Supported values are "Hot" and "Cool"

"storage_account_name" => (Required) The name of the Storage Account where the Container should be created.

"container_access_type" - (Optional) The Access Level configured for this Container. Possible values are blob, container or private. Default is private.