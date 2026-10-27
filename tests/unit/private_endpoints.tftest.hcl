mock_provider "azurerm" {
  alias  = "unit"
  source = "tests/setup/mock_data"
}

mock_provider "azapi" {
  alias  = "unit"
  source = "tests/setup/mock_azapi"
  mock_data "azapi_client_config" {
    defaults = { "client_id" : "00000000-0000-0000-0000-000000000000", "object_id" : "00000000-0000-0000-0000-000000000000", "subscription_id" : "00000000-0000-0000-0000-000000000000", "subscription_resource_id" : "/subscriptions/00000000-0000-0000-0000-000000000000", "tenant_id" : "00000000-0000-0000-0000-000000000000" }
  }
}

variables {
  name                = "kustotest"
  location            = "westeurope"
  resource_group_name = "cluster-rg"
  enable_telemetry    = false
  sku = {
    name     = "Dev(No SLA)_Standard_D11_v2"
    capacity = 1
  }
  tags = {
    common = "cluster"
  }
  lock = {
    kind  = "ReadOnly"
    name  = "cluster-lock"
    notes = "Inherited lock notes"
  }
  role_assignments = {
    reader = {
      name                                   = "00000000-0000-0000-0000-000000000010"
      role_definition_id_or_name             = "Reader"
      principal_id                           = "00000000-0000-0000-0000-000000000020"
      principal_type                         = "ServicePrincipal"
      description                            = "Cluster reader"
      skip_service_principal_aad_check       = true
      condition                              = "!(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'})"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.ManagedIdentity/userAssignedIdentities/delegated"
    }
  }
  private_endpoints = {
    primary = {
      name                            = "pe-primary"
      subnet_resource_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
      subresource_name                = "cluster"
      location                        = "northeurope"
      resource_group_name             = "network-rg"
      network_interface_name          = "primary-nic"
      private_service_connection_name = "primary-connection"
      private_dns_zone_group_name     = "kusto-dns"
      private_dns_zone_resource_ids   = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.westeurope.kusto.windows.net"]
      tags                            = { endpoint = "replacement" }
      application_security_group_associations = {
        clients = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/applicationSecurityGroups/clients"
      }
      ip_configurations = {
        engine = {
          name               = "engine"
          private_ip_address = "10.0.1.4"
          member_name        = "Engine"
        }
        ingestion = {
          name               = "ingestion"
          private_ip_address = "10.0.1.5"
          member_name        = "DataManagement"
        }
      }
      role_assignments = {
        by_name = {
          name                                   = "00000000-0000-0000-0000-000000000030"
          role_definition_id_or_name             = "Reader"
          principal_id                           = "00000000-0000-0000-0000-000000000040"
          principal_type                         = "ServicePrincipal"
          description                            = "Endpoint reader"
          skip_service_principal_aad_check       = true
          condition                              = "!(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'})"
          condition_version                      = "2.0"
          delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.ManagedIdentity/userAssignedIdentities/delegated"
        }
        by_id = {
          role_definition_id_or_name = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
          principal_id               = "00000000-0000-0000-0000-000000000050"
        }
      }
      lock = {
        kind  = "CanNotDelete"
        name  = "endpoint-lock"
        notes = "Endpoint lock notes"
      }
    }
    inherited = {
      name               = "pe-inherited"
      subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
    }
    unlocked = {
      name               = "pe-unlocked"
      subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
      tags               = {}
      lock               = { kind = "None" }
    }
  }
}

run "no_optional_resources" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints = {}
    role_assignments  = {}
    lock              = null
  }

  assert {
    condition = (
      length(output.private_endpoints) == 0 &&
      length(azurerm_role_assignment.private_endpoints) == 0 &&
      length(azurerm_management_lock.private_endpoints) == 0 &&
      length(azurerm_management_lock.this) == 0 &&
      length(azurerm_kusto_cluster.this.identity) == 0
    )
    error_message = "Omitted interfaces must not create endpoints, assignments, locks or identities."
  }
}

run "managed_endpoint_wiring" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  override_resource {
    target = azurerm_private_endpoint.this["primary"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/privateEndpoints/pe-primary"
    }
  }

  assert {
    condition = (
      length(azurerm_private_endpoint.this) == 3 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups) == 0 &&
      toset(keys(output.private_endpoints)) == toset(keys(var.private_endpoints)) &&
      output.private_endpoints["primary"].id == azurerm_private_endpoint.this["primary"].id
    )
    error_message = "Managed endpoints must retain the original resource addresses and output keys."
  }

  assert {
    condition = (
      azurerm_private_endpoint.this["primary"].name == "pe-primary" &&
      azurerm_private_endpoint.this["primary"].location == "northeurope" &&
      azurerm_private_endpoint.this["primary"].resource_group_name == "network-rg" &&
      azurerm_private_endpoint.this["primary"].custom_network_interface_name == "primary-nic" &&
      azurerm_private_endpoint.this["primary"].subnet_id == var.private_endpoints.primary.subnet_resource_id &&
      azurerm_private_endpoint.this["primary"].private_service_connection[0].name == "primary-connection" &&
      azurerm_private_endpoint.this["primary"].private_service_connection[0].private_connection_resource_id == output.resource_id &&
      azurerm_private_endpoint.this["primary"].private_service_connection[0].subresource_names == tolist(["cluster"]) &&
      !azurerm_private_endpoint.this["primary"].private_service_connection[0].is_manual_connection
    )
    error_message = "Endpoint names, scope, network settings and service connection must be forwarded."
  }

  assert {
    condition = (
      azurerm_private_endpoint.this["primary"].private_dns_zone_group[0].name == "kusto-dns" &&
      toset(azurerm_private_endpoint.this["primary"].private_dns_zone_group[0].private_dns_zone_ids) == var.private_endpoints.primary.private_dns_zone_resource_ids &&
      length(azurerm_private_endpoint.this["inherited"].private_dns_zone_group) == 0
    )
    error_message = "DNS groups must use the configured name and zones, and be absent without zone IDs."
  }

  assert {
    condition = (
      tomap({ for config in azurerm_private_endpoint.this["primary"].ip_configuration : config.name => config.member_name }) == tomap({ engine = "Engine", ingestion = "DataManagement" }) &&
      tomap({ for config in azurerm_private_endpoint.this["primary"].ip_configuration : config.name => config.private_ip_address }) == tomap({ engine = "10.0.1.4", ingestion = "10.0.1.5" }) &&
      alltrue([for config in azurerm_private_endpoint.this["primary"].ip_configuration : config.subresource_name == "cluster"])
    )
    error_message = "Each static IP configuration must retain its distinct member, address and group."
  }

  assert {
    condition = (
      azurerm_private_endpoint.this["primary"].tags == tomap({ endpoint = "replacement" }) &&
      azurerm_private_endpoint.this["inherited"].tags == var.tags &&
      length(azurerm_private_endpoint.this["unlocked"].tags) == 0
    )
    error_message = "Endpoint tag overrides must replace tags, with null inheriting and an empty map clearing them."
  }

  assert {
    condition = (
      azurerm_private_endpoint_application_security_group_association.this["primary-clients"].private_endpoint_id == azurerm_private_endpoint.this["primary"].id &&
      azurerm_private_endpoint_application_security_group_association.this["primary-clients"].application_security_group_id == var.private_endpoints.primary.application_security_group_associations.clients
    )
    error_message = "Application security group associations must target the selected endpoint."
  }

  assert {
    condition = (
      length(azurerm_role_assignment.private_endpoints) == 2 &&
      alltrue([for assignment in azurerm_role_assignment.private_endpoints : assignment.scope == azurerm_private_endpoint.this["primary"].id]) &&
      azurerm_role_assignment.private_endpoints[jsonencode(["primary", "by_name"])].role_definition_name == "Reader" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["primary", "by_id"])].role_definition_id == var.private_endpoints.primary.role_assignments.by_id.role_definition_id_or_name &&
      !azurerm_role_assignment.private_endpoints[jsonencode(["primary", "by_id"])].skip_service_principal_aad_check
    )
    error_message = "Endpoint roles must support names and resource IDs without falling back to cluster scope."
  }

  assert {
    condition = alltrue([
      for field in ["name", "principal_id", "principal_type", "description", "condition", "condition_version", "delegated_managed_identity_resource_id", "skip_service_principal_aad_check"] :
      azurerm_role_assignment.private_endpoints[jsonencode(["primary", "by_name"])][field] == var.private_endpoints.primary.role_assignments.by_name[field]
    ])
    error_message = "Every optional endpoint role assignment setting must reach the resource."
  }

  assert {
    condition = (
      azurerm_role_assignment.this["reader"].scope == output.resource_id &&
      alltrue([
        for field in ["name", "principal_id", "principal_type", "description", "condition", "condition_version", "delegated_managed_identity_resource_id", "skip_service_principal_aad_check"] :
        azurerm_role_assignment.this["reader"][field] == var.role_assignments.reader[field]
      ])
    )
    error_message = "Cluster role assignments must preserve their address and honor optional settings."
  }

  assert {
    condition = (
      toset(keys(azurerm_management_lock.private_endpoints)) == toset(["primary", "inherited"]) &&
      azurerm_management_lock.private_endpoints["primary"].name == "endpoint-lock" &&
      azurerm_management_lock.private_endpoints["primary"].lock_level == "CanNotDelete" &&
      azurerm_management_lock.private_endpoints["primary"].notes == "Endpoint lock notes" &&
      azurerm_management_lock.private_endpoints["primary"].scope == azurerm_private_endpoint.this["primary"].id &&
      azurerm_management_lock.private_endpoints["inherited"].lock_level == "ReadOnly" &&
      azurerm_management_lock.private_endpoints["inherited"].notes == "Inherited lock notes" &&
      azurerm_management_lock.private_endpoints["inherited"].scope == azurerm_private_endpoint.this["inherited"].id &&
      azurerm_management_lock.this[0].notes == var.lock.notes
    )
    error_message = "Endpoint locks must honor overrides, inherit the parent lock, and support explicit opt-out."
  }
}

run "externally_managed_dns" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints_manage_dns_zone_group = false
  }

  override_resource {
    target = azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/privateEndpoints/pe-primary"
    }
  }

  assert {
    condition = (
      length(azurerm_private_endpoint.this) == 0 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups) == 3 &&
      alltrue([for endpoint in azurerm_private_endpoint.this_unmanaged_dns_zone_groups : length(endpoint.private_dns_zone_group) == 0]) &&
      output.private_endpoints["primary"].id == azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].id
    )
    error_message = "Disabling DNS management must omit managed groups even when zone IDs are supplied."
  }

  assert {
    condition = (
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].name == "pe-primary" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].location == "northeurope" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].resource_group_name == "network-rg" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].custom_network_interface_name == "primary-nic" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].private_service_connection[0].name == "primary-connection" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].private_service_connection[0].private_connection_resource_id == output.resource_id &&
      tomap({ for config in azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"].ip_configuration : config.name => config.member_name }) == tomap({ engine = "Engine", ingestion = "DataManagement" }) &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["inherited"].tags == var.tags &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups["unlocked"].tags) == 0
    )
    error_message = "External DNS ownership must not change other endpoint settings."
  }

  assert {
    condition = (
      alltrue([for assignment in azurerm_role_assignment.private_endpoints : assignment.scope == output.private_endpoints["primary"].id]) &&
      azurerm_management_lock.private_endpoints["primary"].scope == output.private_endpoints["primary"].id &&
      azurerm_management_lock.private_endpoints["inherited"].scope == output.private_endpoints["inherited"].id &&
      azurerm_private_endpoint_application_security_group_association.this["primary-clients"].private_endpoint_id == output.private_endpoints["primary"].id &&
      !contains(keys(azurerm_management_lock.private_endpoints), "unlocked")
    )
    error_message = "Roles, locks and application security groups must target the external-DNS endpoint."
  }
}

run "managed_endpoint_defaults" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    lock             = null
    role_assignments = {}
    private_endpoints = {
      default = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
        ip_configurations = {
          default = { name = "default", private_ip_address = "10.0.1.6" }
        }
      }
    }
  }

  assert {
    condition = (
      output.private_endpoints["default"].name == "pe-kustotest" &&
      output.private_endpoints["default"].location == var.location &&
      output.private_endpoints["default"].resource_group_name == var.resource_group_name &&
      output.private_endpoints["default"].private_service_connection[0].name == "pse-kustotest" &&
      output.private_endpoints["default"].ip_configuration[0].member_name == "cluster" &&
      output.private_endpoints["default"].ip_configuration[0].subresource_name == "cluster" &&
      length(output.private_endpoints["default"].private_dns_zone_group) == 0 &&
      length(azurerm_management_lock.private_endpoints) == 0 &&
      length(azurerm_role_assignment.private_endpoints) == 0
    )
    error_message = "Existing endpoint defaults must remain intact when optional settings are omitted."
  }
}

run "external_dns_endpoint_defaults" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints_manage_dns_zone_group = false
    lock                                    = null
    role_assignments                        = {}
    private_endpoints = {
      default = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
        ip_configurations = {
          default = { name = "default", private_ip_address = "10.0.1.6" }
        }
      }
    }
  }

  assert {
    condition = (
      output.private_endpoints["default"].name == "pe-kustotest" &&
      output.private_endpoints["default"].location == var.location &&
      output.private_endpoints["default"].resource_group_name == var.resource_group_name &&
      output.private_endpoints["default"].private_service_connection[0].name == "pse-kustotest" &&
      output.private_endpoints["default"].ip_configuration[0].member_name == "cluster" &&
      length(output.private_endpoints["default"].private_dns_zone_group) == 0 &&
      length(azurerm_role_assignment.private_endpoints) == 0 &&
      length(azurerm_management_lock.private_endpoints) == 0
    )
    error_message = "External DNS ownership must preserve endpoint defaults without zone IDs."
  }
}

run "system_assigned_identity" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    managed_identities = { system_assigned = true }
    private_endpoints  = {}
    role_assignments   = {}
    lock               = null
  }

  assert {
    condition     = length(azurerm_kusto_cluster.this.identity) == 1 && azurerm_kusto_cluster.this.identity[0].type == "SystemAssigned"
    error_message = "A system-assigned identity must produce exactly one identity block."
  }
}

run "user_assigned_identity_and_v4_compatibility" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints   = {}
    role_assignments    = {}
    lock                = null
    language_extensions = ["PYTHON_3.10.8", "R"]
    managed_identities = {
      user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test"]
    }
    virtual_network_configuration = {
      subnet_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.Network/virtualNetworks/vnet/subnets/cluster"
      engine_public_ip_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.Network/publicIPAddresses/engine"
      data_management_public_ip_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.Network/publicIPAddresses/management"
    }
  }

  assert {
    condition = (
      length(azurerm_kusto_cluster.this.identity) == 1 &&
      azurerm_kusto_cluster.this.identity[0].type == "UserAssigned" &&
      azurerm_kusto_cluster.this.identity[0].identity_ids == var.managed_identities.user_assigned_resource_ids &&
      azurerm_kusto_cluster.this.virtual_network_configuration[0].data_management_public_ip_id == var.virtual_network_configuration.data_management_public_ip_id
    )
    error_message = "User-assigned identities and the existing virtual-network input must remain functional."
  }

  assert {
    condition = toset(azurerm_kusto_cluster.this.language_extension) == toset([
      { name = "PYTHON", image = "Python3_10_8" },
      { name = "R", image = "R" },
    ])
    error_message = "Legacy language names must map to the correct AzureRM v4 image blocks."
  }
}

run "empty_language_extensions" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints   = {}
    role_assignments    = {}
    lock                = null
    language_extensions = []
  }

  assert {
    condition     = length(azurerm_kusto_cluster.this.language_extension) == 0
    error_message = "An empty language selection must not create extension blocks."
  }
}

run "invalid_subnet_id" {
  command = plan

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints = { invalid = { subnet_resource_id = "not-a-subnet-id" } }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_dns_zone_id" {
  command = plan

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints = {
      invalid = {
        subnet_resource_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
        private_dns_zone_resource_ids = ["not-a-zone-id"]
      }
    }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_application_security_group_id" {
  command = plan

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints = {
      invalid = {
        subnet_resource_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
        application_security_group_associations = { invalid = "not-an-asg-id" }
      }
    }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_endpoint_delegated_identity" {
  command = plan

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    private_endpoints = {
      invalid = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/endpoints"
        role_assignments = {
          invalid = {
            role_definition_id_or_name             = "Reader"
            principal_id                           = "00000000-0000-0000-0000-000000000020"
            delegated_managed_identity_resource_id = "not-an-identity-id"
          }
        }
      }
    }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_cluster_delegated_identity" {
  command = plan

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
  }

  variables {
    role_assignments = {
      invalid = {
        role_definition_id_or_name             = "Reader"
        principal_id                           = "00000000-0000-0000-0000-000000000020"
        delegated_managed_identity_resource_id = "not-an-identity-id"
      }
    }
  }

  expect_failures = [var.role_assignments]
}
