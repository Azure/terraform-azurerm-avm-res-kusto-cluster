resource "azurerm_kusto_cluster" "this" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  # Optional attributes
  allowed_fqdns                      = var.allowed_fqdns
  allowed_ip_ranges                  = var.allowed_ip_ranges
  auto_stop_enabled                  = var.auto_stop_enabled
  disk_encryption_enabled            = var.disk_encryption_enabled
  double_encryption_enabled          = var.double_encryption_enabled
  language_extensions                = var.language_extensions
  outbound_network_access_restricted = var.outbound_network_access_restricted
  public_ip_type                     = var.public_ip_type
  public_network_access_enabled      = var.public_network_access_enabled
  purge_enabled                      = var.purge_enabled
  streaming_ingestion_enabled        = var.streaming_ingestion_enabled
  tags                               = var.tags
  trusted_external_tenants           = var.trusted_external_tenants
  zones                              = var.zones

  sku {
    name     = var.sku.name
    capacity = var.sku.capacity
  }
  dynamic "identity" {
    for_each = var.managed_identities == null ? [] : [var.managed_identities]

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.user_assigned_resource_ids, null)
    }
  }
  dynamic "optimized_auto_scale" {
    for_each = var.optimized_auto_scale == null ? [] : [var.optimized_auto_scale]

    content {
      maximum_instances = optimized_auto_scale.value.maximum_instances
      minimum_instances = optimized_auto_scale.value.minimum_instances
    }
  }
  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_configuration == null ? [] : [var.virtual_network_configuration]

    content {
      data_management_public_ip_id = virtual_network_configuration.value.data_management_public_ip
      engine_public_ip_id          = virtual_network_configuration.value.engine_public_ip_id
      subnet_id                    = virtual_network_configuration.value.subnet_id
    }
  }
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock.kind != "None" ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = azurerm_kusto_cluster.this.id
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_kusto_cluster.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
