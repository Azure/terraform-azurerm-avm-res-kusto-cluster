<!-- BEGIN_TF_DOCS -->
# Example with database, private endpoint and diagnostic profile

This example shows how to deploy the module with a private endpoint connection.
We have also included kusto databases and a diagnostic profile.

To run that test

```shell
terraform -chdir=examples/cluster_with_databases init

terraform -chdir=examples/cluster_with_databases plan -var-file terraform.tfvars

terraform -chdir=examples/cluster_with_databases apply -var-file terraform.tfvars
```

```hcl
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3"
}

# example allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "example" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
  tags = {
    module = "kusto-cluster"
  }
}

resource "azurerm_virtual_network" "example" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  name                = "example-vnet"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_log_analytics_workspace" "example" {
  location            = azurerm_resource_group.example.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.example.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}

resource "azurerm_storage_account" "example" {
  account_replication_type = "ZRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.example.location
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.example.name
}

module "kusto" {
  source = "../../"
  # source  = "Azure/avm-res-kusto-cluster/azurerm"
  # version = "0.1.0"

  enable_telemetry    = false # Disabled for testing. 
  location            = azurerm_resource_group.example.location
  name                = module.naming.kusto_cluster.name_unique
  resource_group_name = azurerm_resource_group.example.name

  allowed_fqdns                       = var.allowed_fqdns
  allowed_ip_ranges                   = var.allowed_ip_ranges
  auto_stop_enabled                   = var.auto_stop_enabled
  disk_encryption_enabled             = var.disk_encryption_enabled
  kusto_cluster_principal_assignments = var.kusto_cluster_principal_assignments
  kusto_database_principal_assignment = var.kusto_database_principal_assignment
  language_extensions                 = var.language_extensions
  lock                                = var.lock
  outbound_network_access_restricted  = var.outbound_network_access_restricted
  public_ip_type                      = var.public_ip_type
  public_network_access_enabled       = var.public_network_access_enabled
  purge_enabled                       = var.purge_enabled
  streaming_ingestion_enabled         = var.streaming_ingestion_enabled
  tags                                = var.tags
  trusted_external_tenants            = var.trusted_external_tenants
  virtual_network_configuration       = var.virtual_network_configuration
  double_encryption_enabled           = var.double_encryption_enabled
  zones                               = var.zones
  sku = {
    name     = "Dev(No SLA)_Standard_D11_v2"
    capacity = 1
  }

  databases = {
    crm = {
      name               = "crm"
      hot_cache_period   = "P30D"
      soft_delete_period = "P30D"
    }
  }

  managed_identities = {
    type = "SystemAssigned"
  }
  # optimized_auto_scale = {
  #   minimum_instances = 2
  #   maximum_instances = 10
  # }

  # Commented as it is impacted by a bug that prevent the deployment to be idempotent https://github.com/Azure/azure-rest-api-specs/issues/22400
  # diagnostic_settings = {
  #   operations = {
  #     name                        = "Operational logs"
  #     workspace_resource_id       = azurerm_log_analytics_workspace.example.id
  #     storage_account_resource_id = azurerm_storage_account.example.id
  #   }
  # }
  private_endpoints = {
    pip1 = {
      subnet_resource_id = azurerm_subnet.example.id
    }
  }

}

# Call the kusto_database submodule directlty and reference the existing kusto cluster
module "kusto_database" {
  source = "../..//modules/azurerm_kusto_database"
  # source  = "Azure/avm-res-kusto-cluster/azurerm//modules/azurerm_kusto_database"
  # version = "0.1.0"

  location            = module.kusto.resource.location
  name                = module.naming.kusto_database.name_unique
  resource_group_name = module.kusto.resource.resource_group_name
  cluster_name        = module.kusto.resource.name
  hot_cache_period    = "P455D"
  soft_delete_period  = "P1D"
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.7.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_log_analytics_workspace.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_resource_group.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_storage_account.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_subnet.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_allowed_fqdns"></a> [allowed\_fqdns](#input\_allowed\_fqdns)

Description: (Optional) List of allowed FQDNs(Fully Qualified Domain Name) for egress from Cluster.

Type: `set(string)`

Default: `null`

### <a name="input_allowed_ip_ranges"></a> [allowed\_ip\_ranges](#input\_allowed\_ip\_ranges)

Description: (Optional) The list of ips in the format of CIDR allowed to connect to the cluster.

Type: `set(string)`

Default: `null`

### <a name="input_auto_stop_enabled"></a> [auto\_stop\_enabled](#input\_auto\_stop\_enabled)

Description: (Optional) Specifies if the cluster could be automatically stopped
(due to lack of data or no activity for many days).

Defaults to true.

Type: `bool`

Default: `true`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: Customer managed keys that should be associated with the resource.

Type:

```hcl
object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
```

Default: `null`

### <a name="input_databases"></a> [databases](#input\_databases)

Description: (Optional) A map of kusto database objects:

- `name` - (Required) The name of the Kusto Database to create. Changing this forces a new resource to be created.
- `location` - (Optional) The location where the Kusto Database should be created. If not provided, will default to the location of the kusto cluster. Changing this forces a new resource to be created.
- `resource_group_name` - (Optional) Specifies the Resource Group where the Kusto Database should exist. If not provided, will default to the location of the kusto cluster. Changing this forces a new resource to be created.
- `cluster_name` - (Optional) Specifies the name of the Kusto Cluster this database will be added to. If not provided, will default to the location of the kusto cluster. Changing this forces a new resource to be created.
- `hot_cache_period` - (Optional) The time the data that should be kept in cache for fast queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan.
- `soft_delete_period` - (Optional) The time the data should be kept before it stops being accessible to queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan

Type:

```hcl
map(object({
    name                = string
    location            = optional(string, null)
    resource_group_name = optional(string, null)
    cluster_name        = optional(string, null)
    hot_cache_period    = optional(string)
    soft_delete_period  = optional(string)
  }))
```

Default: `{}`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_disk_encryption_enabled"></a> [disk\_encryption\_enabled](#input\_disk\_encryption\_enabled)

Description: (Optional) Specifies if the cluster's disks are encrypted.

Type: `bool`

Default: `true`

### <a name="input_double_encryption_enabled"></a> [double\_encryption\_enabled](#input\_double\_encryption\_enabled)

Description: (Optional) Is the cluster's double encryption enabled? Changing this forces a new resource to be created.

Type: `bool`

Default: `null`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_kusto_cluster_principal_assignments"></a> [kusto\_cluster\_principal\_assignments](#input\_kusto\_cluster\_principal\_assignments)

Description: A map that manages a Kusto Cluster Principal Assignment.

- `name` (Required) The name of the Kusto cluster principal assignment. Changing this forces a new resource to be created.
- `principal_id` (Required) The object id of the principal. Changing this forces a new resource to be created.
- `principal_type` (Required) The type of the principal. Valid values include App, Group, User. Changing this forces a new resource to be created.
- `role` (Required) The cluster role assigned to the principal. Valid values include AllDatabasesAdmin and AllDatabasesViewer. Changing this forces a new resource to be created.
- `tenant_id` (Required) The tenant id in which the principal resides. Changing this forces a new resource to be created.

Type:

```hcl
map(object({
    name           = string
    principal_id   = string
    principal_type = string
    role           = string
    tenant_id      = string
  }))
```

Default: `{}`

### <a name="input_kusto_database_principal_assignment"></a> [kusto\_database\_principal\_assignment](#input\_kusto\_database\_principal\_assignment)

Description: A map that manages a Kusto (also known as Azure Data Explorer) Database Principal Assignment.

- `database_name` (Required) The name of the database in which to create the resource. Changing this forces a new resource to be created.
- `name` (Required) The name of the Kusto cluster principal assignment. Changing this forces a new resource to be created.
- `principal_id` (Required) The object id of the principal. Changing this forces a new resource to be created.
- `principal_type` (Required) The type of the principal. Valid values include App, Group, User. Changing this forces a new resource to be created.
- `role` (Required) The cluster role assigned to the principal. Valid values include AllDatabasesAdmin and AllDatabasesViewer. Changing this forces a new resource to be created.
- `tenant_id` (Required) The tenant id in which the principal resides. Changing this forces a new resource to be created.

Type:

```hcl
map(object({
    database_name  = string
    name           = string
    principal_id   = string
    principal_type = string
    role           = string
    tenant_id      = string
  }))
```

Default: `{}`

### <a name="input_language_extensions"></a> [language\_extensions](#input\_language\_extensions)

Description: (Optional) An list of language\_extensions to enable.   

Valid values are: PYTHON, PYTHON\_3.10.8 and R.   

PYTHON is used to specify Python 3.6.5 image and PYTHON\_3.10.8 is used to specify Python 3.10.8 image.  
Note that PYTHON\_3.10.8 is only available in skus which support nested virtualization.

NOTE:  
In v4.0.0 and later version of the AzureRM Provider,   
language\_extensions will be changed to a list of language\_extension block.   
In each block, name and image are required.   
name is the name of the language extension, possible values are PYTHON, R.   
image is the image of the language extension, possible values are Python3\_6\_5, Python3\_10\_8 and R.

Type: `set(string)`

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description:   Controls the Resource Lock configuration for this resource. The following properties can be specified:

  - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description:   Controls the Managed Identity configuration on this resource. The following properties can be specified:

  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_optimized_auto_scale"></a> [optimized\_auto\_scale](#input\_optimized\_auto\_scale)

Description: A optimized\_auto\_scale block supports the following:

minimum\_instances - (Required) The minimum number of allowed instances. Must between 0 and 1000.

maximum\_instances - (Required) The maximum number of allowed instances. Must between 0 and 1000.

Type:

```hcl
object({
    maximum_instances = number
    minimum_instances = number
  })
```

Default: `null`

### <a name="input_outbound_network_access_restricted"></a> [outbound\_network\_access\_restricted](#input\_outbound\_network\_access\_restricted)

Description: (Optional) Whether to restrict outbound network access.   
Value is optional but if passed in, must be true or false.  

Default is false.

Type: `bool`

Default: `false`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description: A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.

Type:

```hcl
map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
```

Default: `{}`

### <a name="input_public_ip_type"></a> [public\_ip\_type](#input\_public\_ip\_type)

Description: (Optional) Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6). Defaults to IPv4.

Type: `string`

Default: `"IPv4"`

### <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled)

Description: (Optional) Is the public network access enabled? Defaults to true.

Type: `bool`

Default: `false`

### <a name="input_purge_enabled"></a> [purge\_enabled](#input\_purge\_enabled)

Description: (Optional) Specifies if the purge operations are enabled.

Type: `bool`

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.
- `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_streaming_ingestion_enabled"></a> [streaming\_ingestion\_enabled](#input\_streaming\_ingestion\_enabled)

Description: (Optional) Specifies if the streaming ingest is enabled.

Type: `bool`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Map of tags to assign to the resource.

Type: `map(string)`

Default: `null`

### <a name="input_trusted_external_tenants"></a> [trusted\_external\_tenants](#input\_trusted\_external\_tenants)

Description: (Optional) Specifies a list of tenant IDs that are trusted by the cluster.   
New or updated Kusto Cluster will only allow your own tenant by default.

Use trusted\_external\_tenants = ["*"] to explicitly allow all other tenants,   
trusted\_external\_tenants = [] for only your tenant or   
trusted\_external\_tenants = ["<tenantId1>", "<tenantIdx>"] to allow specific other tenants.

Type: `set(string)`

Default: `[]`

### <a name="input_virtual_network_configuration"></a> [virtual\_network\_configuration](#input\_virtual\_network\_configuration)

Description: (Optional) A virtual\_network\_configuration block as defined below.   
Changing this forces a new resource to be created.

A virtual\_network\_configuration block supports the following:

subnet\_id - (Required) The subnet resource id.

engine\_public\_ip\_id - (Required) Engine service's public IP address resource id.

data\_management\_public\_ip\_id - (Required) Data management's service public IP address resource id.

Type:

```hcl
object({
    data_management_public_ip_id = string
    engine_public_ip_id          = string
    subnet_id                    = string
  })
```

Default: `null`

### <a name="input_zones"></a> [zones](#input\_zones)

Description: (Optional) Specifies a list of Availability Zones in which this Kusto Cluster should be located. Changing this forces a new Kusto Cluster to be created.

Type: `set(string)`

Default: `null`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_kusto"></a> [kusto](#module\_kusto)

Source: ../../

Version:

### <a name="module_kusto_database"></a> [kusto\_database](#module\_kusto\_database)

Source: ../..//modules/azurerm_kusto_database

Version:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: >= 0.3

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/regions/azurerm

Version: >= 0.3

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

You can opt-out by setting the variable

```hcl
enable_telemetry = false
```
<!-- END_TF_DOCS -->