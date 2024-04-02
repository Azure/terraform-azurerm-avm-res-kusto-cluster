variable "cluster_name" {
  type        = string
  description = "(Required) The name of the cluster in which to create the resource. Changing this forces a new resource to be created."
}

variable "name" {
  type        = string
  description = "(Required) The name of the Kusto cluster principal assignment. Changing this forces a new resource to be created."
}

variable "principal_id" {
  type        = string
  description = "(Required) The object id of the principal. Changing this forces a new resource to be created."

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.principal_id))
    error_message = "The value you have set is not a valid GUID."
  }
}

variable "principal_type" {
  type        = string
  description = "(Required) The type of the principal. Valid values include App, Group, User. Changing this forces a new resource to be created."

  validation {
    condition = contains(["App", "Group", "User"], var.principal_type)
    error_message = format("Only the following values are authorised: 'App', 'Group' and 'User'. Fix the value you have set to: [%s]", join(", ",
      setsubtract([var.principal_type], ["App", "Group", "User"]))
    )
  }
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the resource. Changing this forces a new resource to be created."
}

variable "role" {
  type        = string
  description = "(Required) The cluster role assigned to the principal. Valid values include AllDatabasesAdmin and AllDatabasesViewer. Changing this forces a new resource to be created."

  validation {
    condition = contains(["AllDatabasesAdmin", "AllDatabasesViewer"], var.role)
    error_message = format("Only the following values are authorised: 'AllDatabasesAdmin' or 'AllDatabasesViewer'. Fix the value you have set to: [%s]", join(", ",
      setsubtract([var.role], ["AllDatabasesAdmin", "AllDatabasesViewer"]))
    )
  }
}

variable "tenant_id" {
  type        = string
  description = "(Required) The tenant id in which the principal resides. Changing this forces a new resource to be created."

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "The value you have set is not a valid GUID."
  }
}
