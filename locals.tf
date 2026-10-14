locals {
  language_extension_images = {
    PYTHON          = "Python3_6_5"
    "PYTHON_3.10.8" = "Python3_10_8"
    R               = "R"
  }
  private_endpoints = merge(
    azurerm_private_endpoint.this,
    azurerm_private_endpoint.this_unmanaged_dns_zone_groups,
  )
  private_endpoint_locks = {
    for pe_key, endpoint in var.private_endpoints :
    pe_key => endpoint.lock != null ? endpoint.lock : var.lock
    if endpoint.lock != null ? endpoint.lock.kind != "None" : var.lock != null
  }
  private_endpoint_role_assignments = {
    for assignment in flatten([
      for pe_key, endpoint in var.private_endpoints : [
        for role_key, role in endpoint.role_assignments : {
          key    = jsonencode([pe_key, role_key])
          pe_key = pe_key
          role   = role
        }
      ]
    ]) : assignment.key => assignment
  }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
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
