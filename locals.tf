locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}

locals {
  managed_identities = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
    type = (
      var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0
      ? "SystemAssigned, UserAssigned"
      : var.managed_identities.system_assigned
      ? "SystemAssigned"
      : "UserAssigned"
    )
    user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
  } : null
}

# Private endpoint application security group associations
# Remove if this resource does not support private endpoints
locals {
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
}
