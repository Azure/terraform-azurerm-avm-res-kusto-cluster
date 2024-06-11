# tflint-ignore: terraform_unused_declarations
variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed.  If null, the location will be inferred from the resource group location."
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "name" {
  type        = string
  description = "The name of the this resource."

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{3,21}$", var.name))
    error_message = "The name must be between 3 and 21 characters long and can only contain lowercase letters and numbers."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

# tflint-ignore: terraform_unused_declarations
variable "sku" {
  type = object({
    name     = string
    capacity = number
  })
  description = <<-DESCRIPTION
  A sku block supports the following:

  name - (Required) The name of the SKU. 
  
  Possible values are:
  - Dev(No SLA)_Standard_D11_v2, 
  - Dev(No SLA)_Standard_E2a_v4, 
  - Standard_D14_v2, 
  - Standard_D11_v2, 
  - Standard_D16d_v5, 
  - Standard_D13_v2, 
  - Standard_D12_v2, 
  - Standard_DS14_v2+4TB_PS, 
  - Standard_DS14_v2+3TB_PS, 
  - Standard_DS13_v2+1TB_PS, 
  - Standard_DS13_v2+2TB_PS, 
  - Standard_D32d_v5, 
  - Standard_D32d_v4, 
  - Standard_EC8ads_v5, 
  - Standard_EC8as_v5+1TB_PS, 
  - Standard_EC8as_v5+2TB_PS, 
  - Standard_EC16ads_v5, 
  - Standard_EC16as_v5+4TB_PS, 
  - Standard_EC16as_v5+3TB_PS, 
  - Standard_E80ids_v4, 
  - Standard_E8a_v4, 
  - Standard_E8ads_v5, 
  - Standard_E8as_v5+1TB_PS, 
  - Standard_E8as_v5+2TB_PS, 
  - Standard_E8as_v4+1TB_PS, 
  - Standard_E8as_v4+2TB_PS, 
  - Standard_E8d_v5, 
  - Standard_E8d_v4, 
  - Standard_E8s_v5+1TB_PS, 
  - Standard_E8s_v5+2TB_PS, 
  - Standard_E8s_v4+1TB_PS, 
  - Standard_E8s_v4+2TB_PS, 
  - Standard_E4a_v4, 
  - Standard_E4ads_v5, 
  - Standard_E4d_v5, 
  - Standard_E4d_v4, 
  - Standard_E16a_v4, 
  - Standard_E16ads_v5, 
  - Standard_E16as_v5+4TB_PS, 
  - Standard_E16as_v5+3TB_PS, 
  - Standard_E16as_v4+4TB_PS, 
  - Standard_E16as_v4+3TB_PS, 
  - Standard_E16d_v5, 
  - Standard_E16d_v4, 
  - Standard_E16s_v5+4TB_PS, 
  - Standard_E16s_v5+3TB_PS, 
  - Standard_E16s_v4+4TB_PS, 
  - Standard_E16s_v4+3TB_PS, 
  - Standard_E64i_v3, 
  - Standard_E2a_v4, 
  - Standard_E2ads_v5, 
  - Standard_E2d_v5, 
  - Standard_E2d_v4, 
  - Standard_L8as_v3, 
  - Standard_L8s, 
  - Standard_L8s_v3, 
  - Standard_L8s_v2, 
  - Standard_L4s, 
  - Standard_L16as_v3, 
  - Standard_L16s, 
  - Standard_L16s_v3, 
  - Standard_L16s_v2, 
  - Standard_L32as_v3 
  - Standard_L32s_v3
  capacity - (Optional) Specifies the node count for the cluster. Boundaries depend on the SKU name.
  NOTE:
  If no optimized_auto_scale block is defined, then the capacity is required. ~> NOTE: If an optimized_auto_scale block is defined and no capacity is set, then the capacity is initially set to the value of minimum_instances.
  DESCRIPTION

  validation {
    condition = contains([
      "Dev(No SLA)_Standard_D11_v2",
      "Dev(No SLA)_Standard_E2a_v4",
      "Standard_D14_v2",
      "Standard_D11_v2",
      "Standard_D16d_v5",
      "Standard_D13_v2",
      "Standard_D12_v2",
      "Standard_DS14_v2+4TB_PS",
      "Standard_DS14_v2+3TB_PS",
      "Standard_DS13_v2+1TB_PS",
      "Standard_DS13_v2+2TB_PS",
      "Standard_D32d_v5",
      "Standard_D32d_v4",
      "Standard_EC8ads_v5",
      "Standard_EC8as_v5+1TB_PS",
      "Standard_EC8as_v5+2TB_PS",
      "Standard_EC16ads_v5",
      "Standard_EC16as_v5+4TB_PS",
      "Standard_EC16as_v5+3TB_PS",
      "Standard_E80ids_v4",
      "Standard_E8a_v4",
      "Standard_E8ads_v5",
      "Standard_E8as_v5+1TB_PS",
      "Standard_E8as_v5+2TB_PS",
      "Standard_E8as_v4+1TB_PS",
      "Standard_E8as_v4+2TB_PS",
      "Standard_E8d_v5",
      "Standard_E8d_v4",
      "Standard_E8s_v5+1TB_PS",
      "Standard_E8s_v5+2TB_PS",
      "Standard_E8s_v4+1TB_PS",
      "Standard_E8s_v4+2TB_PS",
      "Standard_E4a_v4",
      "Standard_E4ads_v5",
      "Standard_E4d_v5",
      "Standard_E4d_v4",
      "Standard_E16a_v4",
      "Standard_E16ads_v5",
      "Standard_E16as_v5+4TB_PS",
      "Standard_E16as_v5+3TB_PS",
      "Standard_E16as_v4+4TB_PS",
      "Standard_E16as_v4+3TB_PS",
      "Standard_E16d_v5",
      "Standard_E16d_v4",
      "Standard_E16s_v5+4TB_PS",
      "Standard_E16s_v5+3TB_PS",
      "Standard_E16s_v4+4TB_PS",
      "Standard_E16s_v4+3TB_PS",
      "Standard_E64i_v3",
      "Standard_E2a_v4",
      "Standard_E2ads_v5",
      "Standard_E2d_v5",
      "Standard_E2d_v4",
      "Standard_L8as_v3",
      "Standard_L8s",
      "Standard_L8s_v3",
      "Standard_L8s_v2",
      "Standard_L4s",
      "Standard_L16as_v3",
      "Standard_L16s",
      "Standard_L16s_v3",
      "Standard_L16s_v2",
      "Standard_L32as_v3",
      "Standard_L32s_v3"
    ], var.sku.name)
    error_message = "sku.name must be set to an authorised value. See documentation."
  }
}

variable "allowed_fqdns" {
  type        = set(string)
  default     = null
  description = "(Optional) List of allowed FQDNs(Fully Qualified Domain Name) for egress from Cluster."
}

variable "allowed_ip_ranges" {
  type        = set(string)
  default     = null
  description = "(Optional) The list of ips in the format of CIDR allowed to connect to the cluster."
}

variable "auto_stop_enabled" {
  type        = bool
  default     = true
  description = <<-DESCRIPTION
  (Optional) Specifies if the cluster could be automatically stopped 
  (due to lack of data or no activity for many days). 

  Defaults to true.
  DESCRIPTION
}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = "Customer managed keys that should be associated with the resource."
}

# tflint-ignore: terraform_unused_declarations
variable "databases" {
  type = map(object({
    name                = string
    location            = optional(string, null)
    resource_group_name = optional(string, null)
    cluster_name        = optional(string, null)
    hot_cache_period    = optional(string)
    soft_delete_period  = optional(string)
  }))
  default     = {}
  description = <<-DESCRIPTION
  (Optional) A map of kusto database objects:

  - `name` - (Required) The name of the Kusto Database to create. Changing this forces a new resource to be created.
  - `location` - (Optional) The location where the Kusto Database should be created. If not provided, will default to the location of the kusto cluster. Changing this forces a new resource to be created.
  - `resource_group_name` - (Optional) Specifies the Resource Group where the Kusto Database should exist. If not provided, will default to the location of the kusto cluster. Changing this forces a new resource to be created.
  - `cluster_name` - (Optional) Specifies the name of the Kusto Cluster this database will be added to. If not provided, will default to the location of the kusto cluster. Changing this forces a new resource to be created.
  - `hot_cache_period` - (Optional) The time the data that should be kept in cache for fast queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan.
  - `soft_delete_period` - (Optional) The time the data should be kept before it stops being accessible to queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan
  DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue(
      [
        for k in keys(var.databases) : can(regex("^[a-zA-Z0-9- .]{1,260}$", var.databases[k].name))
      ]
    )
    error_message = format("The following database name is not valid. Adjust the database name for the map (must match regex: '^[a-zA-Z0-9- .]{1,260}$'): %s", join(", ",
      [
        for k in keys(var.databases) : format("'%s -> %s'", k, var.databases[k].name)
        if can(regex("^[a-zA-Z0-9- .]{1,260}$", var.databases[k].name)) == false
      ]
      )
    )
  }
}

# tflint-ignore: terraform_unused_declarations
variable "diagnostic_settings" {
  type = map(object({
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
  default     = {}
  description = <<-DESCRIPTION
  A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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
  DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "disk_encryption_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies if the cluster's disks are encrypted."
}

variable "double_encryption_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Is the cluster's double encryption enabled? Changing this forces a new resource to be created."
}

# tflint-ignore: terraform_unused_declarations
variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<-DESCRIPTION
  This variable controls whether or not telemetry is enabled for the module.
  For more information see <https://aka.ms/avm/telemetryinfo>.
  If it is set to false, then no telemetry will be collected.
  DESCRIPTION
}

variable "kusto_cluster_principal_assignments" {
  type = map(object({
    name           = string
    principal_id   = string
    principal_type = string
    role           = string
    tenant_id      = string
  }))
  default     = {}
  description = <<-DESCRIPTION
  A map that manages a Kusto Cluster Principal Assignment.

  - `name` (Required) The name of the Kusto cluster principal assignment. Changing this forces a new resource to be created.
  - `principal_id` (Required) The object id of the principal. Changing this forces a new resource to be created.
  - `principal_type` (Required) The type of the principal. Valid values include App, Group, User. Changing this forces a new resource to be created.
  - `role` (Required) The cluster role assigned to the principal. Valid values include AllDatabasesAdmin and AllDatabasesViewer. Changing this forces a new resource to be created.
  - `tenant_id` (Required) The tenant id in which the principal resides. Changing this forces a new resource to be created.
  DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue(
      [for _, v in var.kusto_cluster_principal_assignments : contains(["App", "Group", "User"], v.principal_type)]
    )
    error_message = format("Only the following values are authorised: 'App', 'Group' or 'User'. Fix the value you have set to: [%s]", join(", ",
      setsubtract(
        [for _, v in var.kusto_cluster_principal_assignments : v.principal_type],
        ["App", "Group", "User"]
      ))
    )
  }
  validation {
    condition = alltrue(
      [for _, v in var.kusto_cluster_principal_assignments : contains(["AllDatabasesAdmin", "AllDatabasesViewer"], v.role)]
    )
    error_message = format("Only the following values are authorised: 'AllDatabasesAdmin' or 'AllDatabasesViewer'. Fix the value you have set to: [%s]", join(", ",
      setsubtract(
        [for _, v in var.kusto_cluster_principal_assignments : v.role],
        ["AllDatabasesAdmin", "AllDatabasesViewer"]
      ))
    )
  }
}

variable "kusto_database_principal_assignment" {
  type = map(object({
    database_name  = string
    name           = string
    principal_id   = string
    principal_type = string
    role           = string
    tenant_id      = string
  }))
  default     = {}
  description = <<-DESCRIPTION
  A map that manages a Kusto (also known as Azure Data Explorer) Database Principal Assignment.

  - `database_name` (Required) The name of the database in which to create the resource. Changing this forces a new resource to be created.
  - `name` (Required) The name of the Kusto cluster principal assignment. Changing this forces a new resource to be created.
  - `principal_id` (Required) The object id of the principal. Changing this forces a new resource to be created.
  - `principal_type` (Required) The type of the principal. Valid values include App, Group, User. Changing this forces a new resource to be created.
  - `role` (Required) The cluster role assigned to the principal. Valid values include AllDatabasesAdmin and AllDatabasesViewer. Changing this forces a new resource to be created.
  - `tenant_id` (Required) The tenant id in which the principal resides. Changing this forces a new resource to be created.
  DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue(
      [for _, v in var.kusto_database_principal_assignment : contains(["App", "Group", "User"], v.principal_type)]
    )
    error_message = format("Only the following values are authorised: 'App', 'Group' or 'User'. Fix the value you have set to: [%s]", join(", ",
      setsubtract(
        [for _, v in var.kusto_database_principal_assignment : v.principal_type],
        ["App", "Group", "User"]
      ))
    )
  }
  validation {
    condition = alltrue(
      [for _, v in var.kusto_database_principal_assignment : contains(["Admin", "Ingestor", "Monitor", "UnrestrictedViewer", "User", "Viewer"], v.role)]
    )
    error_message = format("Only the following values are authorised: 'Admin', 'Ingestor', 'Monitor', 'UnrestrictedViewer', 'User' or 'Viewer'. Fix the value you have set to: [%s]", join(", ",
      setsubtract(
        [for _, v in var.kusto_database_principal_assignment : v.role],
        ["Admin", "Ingestor", "Monitor", "UnrestrictedViewer", "User", "Viewer"]
      ))
    )
  }
}

variable "language_extensions" {
  type        = set(string)
  default     = null
  description = <<-DESCRIPTION
  (Optional) An list of language_extensions to enable. 
  
  Valid values are: PYTHON, PYTHON_3.10.8 and R. 
  
  PYTHON is used to specify Python 3.6.5 image and PYTHON_3.10.8 is used to specify Python 3.10.8 image.
  Note that PYTHON_3.10.8 is only available in skus which support nested virtualization.

  NOTE:
  In v4.0.0 and later version of the AzureRM Provider, 
  language_extensions will be changed to a list of language_extension block. 
  In each block, name and image are required. 
  name is the name of the language extension, possible values are PYTHON, R. 
  image is the image of the language extension, possible values are Python3_6_5, Python3_10_8 and R.
  DESCRIPTION

  validation {
    condition     = var.language_extensions == null ? true : setunion(["PYTHON", "PYTHON_3.10.8", "R"], var.language_extensions) == toset(["PYTHON", "PYTHON_3.10.8", "R"])
    error_message = "Only set an authorised language 'PYTHON', 'PYTHON_3.10.8', 'R'"
  }
}

variable "lock" {
  type = object({
    name = optional(string, null)
    kind = string
  })
  default     = null
  description = "The lock level to apply. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`."

  validation {
    condition     = var.lock == null ? true : contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = "Managed identities to be created for the resource."
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "optimized_auto_scale" {
  type = object({
    maximum_instances = number
    minimum_instances = number
  })
  default     = null
  description = <<-DESCRIPTION
  A optimized_auto_scale block supports the following:

  minimum_instances - (Required) The minimum number of allowed instances. Must between 0 and 1000.

  maximum_instances - (Required) The maximum number of allowed instances. Must between 0 and 1000.
  DESCRIPTION

  validation {
    condition = var.optimized_auto_scale == null ? true : (
      var.optimized_auto_scale.maximum_instances >= 2 && var.optimized_auto_scale.maximum_instances <= 1000
    )
    error_message = "The maximum number of allowed instances. Must between 2 and 1000."
  }
  validation {
    condition = var.optimized_auto_scale == null ? true : (
      var.optimized_auto_scale.minimum_instances >= 2 && var.optimized_auto_scale.minimum_instances <= 1000
    )
    error_message = "The minimum number of allowed instances. Must between 2 and 1000."
  }
  validation {
    condition = var.optimized_auto_scale == null ? true : (
      var.optimized_auto_scale.maximum_instances > var.optimized_auto_scale.minimum_instances
    )
    error_message = "The maximum number of instances should be greater than the minimum number."
  }
}

variable "outbound_network_access_restricted" {
  type        = bool
  default     = false
  description = <<-DESCRIPTION
  (Optional) Whether to restrict outbound network access. 
  Value is optional but if passed in, must be true or false.
  
  Default is false.
  DESCRIPTION
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "private_endpoints" {
  type = map(object({
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
  default     = {}
  description = <<DESCRIPTION
A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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
DESCRIPTION
  nullable    = false
}

variable "public_ip_type" {
  type        = string
  default     = "IPv4"
  description = "(Optional) Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6). Defaults to IPv4."
  nullable    = false

  validation {
    condition     = contains(["IPv4", "IPv6"], var.public_ip_type)
    error_message = "The public_ip_type must be either 'IPv4' or 'IPv6'."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Is the public network access enabled? Defaults to true."
  nullable    = false
}

variable "purge_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Specifies if the purge operations are enabled."
}

# tflint-ignore: terraform_unused_declarations
variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<-DESCRIPTION
  A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

  - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
  - `principal_id` - The ID of the principal to assign the role to.
  - `description` - The description of the role assignment.
  - `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
  - `condition` - The condition which will be used to scope the role assignment.
  - `condition_version` - The version of the condition syntax. Valid values are '2.0'.
  - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

  > Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
  DESCRIPTION
  nullable    = false
}

variable "streaming_ingestion_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Specifies if the streaming ingest is enabled."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Map of tags to assign to the resource."
}

variable "trusted_external_tenants" {
  type        = set(string)
  default     = []
  description = <<-DESCRIPTION
  (Optional) Specifies a list of tenant IDs that are trusted by the cluster. 
  New or updated Kusto Cluster will only allow your own tenant by default. 

  Use trusted_external_tenants = ["*"] to explicitly allow all other tenants, 
  trusted_external_tenants = [] for only your tenant or 
  trusted_external_tenants = ["<tenantId1>", "<tenantIdx>"] to allow specific other tenants.
  DESCRIPTION
}

variable "virtual_network_configuration" {
  type = object({
    data_management_public_ip_id = string
    engine_public_ip_id          = string
    subnet_id                    = string
  })
  default     = null
  description = <<-DESCRIPTION
  (Optional) A virtual_network_configuration block as defined below. 
  Changing this forces a new resource to be created.

  A virtual_network_configuration block supports the following:

  subnet_id - (Required) The subnet resource id.

  engine_public_ip_id - (Required) Engine service's public IP address resource id.

  data_management_public_ip_id - (Required) Data management's service public IP address resource id.
  DESCRIPTION
}

variable "zones" {
  type        = set(string)
  default     = null
  description = "(Optional) Specifies a list of Availability Zones in which this Kusto Cluster should be located. Changing this forces a new Kusto Cluster to be created."

  validation {
    condition     = var.zones == null ? true : setunion(["1", "2", "3"], var.zones) == toset(["1", "2", "3"])
    error_message = "Zones can be null or a combination of '1', '2' or '3'"
  }
}
