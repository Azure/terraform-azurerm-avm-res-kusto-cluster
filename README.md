<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

Things to do:

1. Set up a GitHub repo environment called `test`.
1. Configure environment protection rule to ensure that approval is required before deploying to this environment.
1. Create a user-assigned managed identity in your test subscription.
1. Create a role assignment for the managed identity on your test subscription, use the minimum required role.
1. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.
1. Search and update TODOs within the code and remove the TODO comments once complete.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.6.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.88.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.88.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0)

## Resources

The following resources are used by this module:

- [azurerm_kusto_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_cluster) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: A sku block supports the following:

name - (Required) The name of the SKU.   

Possible values are:
- Dev(No SLA)\_Standard\_D11\_v2,
- Dev(No SLA)\_Standard\_E2a\_v4,
- Standard\_D14\_v2,
- Standard\_D11\_v2,
- Standard\_D16d\_v5,
- Standard\_D13\_v2,
- Standard\_D12\_v2,
- Standard\_DS14\_v2+4TB\_PS,
- Standard\_DS14\_v2+3TB\_PS,
- Standard\_DS13\_v2+1TB\_PS,
- Standard\_DS13\_v2+2TB\_PS,
- Standard\_D32d\_v5,
- Standard\_D32d\_v4,
- Standard\_EC8ads\_v5,
- Standard\_EC8as\_v5+1TB\_PS,
- Standard\_EC8as\_v5+2TB\_PS,
- Standard\_EC16ads\_v5,
- Standard\_EC16as\_v5+4TB\_PS,
- Standard\_EC16as\_v5+3TB\_PS,
- Standard\_E80ids\_v4,
- Standard\_E8a\_v4,
- Standard\_E8ads\_v5,
- Standard\_E8as\_v5+1TB\_PS,
- Standard\_E8as\_v5+2TB\_PS,
- Standard\_E8as\_v4+1TB\_PS,
- Standard\_E8as\_v4+2TB\_PS,
- Standard\_E8d\_v5,
- Standard\_E8d\_v4,
- Standard\_E8s\_v5+1TB\_PS,
- Standard\_E8s\_v5+2TB\_PS,
- Standard\_E8s\_v4+1TB\_PS,
- Standard\_E8s\_v4+2TB\_PS,
- Standard\_E4a\_v4,
- Standard\_E4ads\_v5,
- Standard\_E4d\_v5,
- Standard\_E4d\_v4,
- Standard\_E16a\_v4,
- Standard\_E16ads\_v5,
- Standard\_E16as\_v5+4TB\_PS,
- Standard\_E16as\_v5+3TB\_PS,
- Standard\_E16as\_v4+4TB\_PS,
- Standard\_E16as\_v4+3TB\_PS,
- Standard\_E16d\_v5,
- Standard\_E16d\_v4,
- Standard\_E16s\_v5+4TB\_PS,
- Standard\_E16s\_v5+3TB\_PS,
- Standard\_E16s\_v4+4TB\_PS,
- Standard\_E16s\_v4+3TB\_PS,
- Standard\_E64i\_v3,
- Standard\_E2a\_v4,
- Standard\_E2ads\_v5,
- Standard\_E2d\_v5,
- Standard\_E2d\_v4,
- Standard\_L8as\_v3,
- Standard\_L8s,
- Standard\_L8s\_v3,
- Standard\_L8s\_v2,
- Standard\_L4s,
- Standard\_L16as\_v3,
- Standard\_L16s,
- Standard\_L16s\_v3,
- Standard\_L16s\_v2,
- Standard\_L32as\_v3
- Standard\_L32s\_v3  
capacity - (Optional) Specifies the node count for the cluster. Boundaries depend on the SKU name.  
NOTE:  
If no optimized\_auto\_scale block is defined, then the capacity is required. ~> NOTE: If an optimized\_auto\_scale block is defined and no capacity is set, then the capacity is initially set to the value of minimum\_instances.

Type:

```hcl
object({
    name     = string
    capacity = number
  })
```

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
    key_vault_resource_id              = optional(string)
    key_name                           = optional(string)
    key_version                        = optional(string, null)
    user_assigned_identity_resource_id = optional(string, null)
  })
```

Default: `{}`

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

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.  If null, the location will be inferred from the resource group location.

Type: `string`

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: The lock level to apply. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.

Type:

```hcl
object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
```

Default: `{}`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Managed identities to be created for the resource.

Type:

```hcl
object({
    type                       = string
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `null`

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
    })), {})
    lock = optional(object({
      name = optional(string, null)
      kind = optional(string, "None")
    }), {})
    tags                                    = optional(map(any), null)
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

The following outputs are exported:

### <a name="output_data_ingestion_uri"></a> [data\_ingestion\_uri](#output\_data\_ingestion\_uri)

Description: The Kusto Cluster URI to be used for data ingestion.

### <a name="output_id"></a> [id](#output\_id)

Description: The Kusto Cluster ID.

### <a name="output_identity"></a> [identity](#output\_identity)

Description: An identity block exports the following:

principal\_id - The Principal ID associated with this System Assigned Managed Service Identity.

tenant\_id - The Tenant ID associated with this System Assigned Managed Service Identity.

### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

Description: A map of private endpoints. The map key is the supplied input to var.private\_endpoints. The map value is the entire azurerm\_private\_endpoint resource.

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full output for the resource.

### <a name="output_uri"></a> [uri](#output\_uri)

Description: The FQDN of the Azure Kusto Cluster.

## Modules

The following Modules are called:

### <a name="module_kusto_cluster_principal_assignment"></a> [kusto\_cluster\_principal\_assignment](#module\_kusto\_cluster\_principal\_assignment)

Source: ./modules/azurerm_kusto_cluster_principal_assignment

Version:

### <a name="module_kusto_database"></a> [kusto\_database](#module\_kusto\_database)

Source: ./modules/azurerm_kusto_database

Version:

### <a name="module_kusto_database_principal_assignment"></a> [kusto\_database\_principal\_assignment](#module\_kusto\_database\_principal\_assignment)

Source: ./modules/azurerm_kusto_database_principal_assignment

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->