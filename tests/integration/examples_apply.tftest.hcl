provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

run "setup" {
  command = apply

  module {
    source = "./tests/setup/dependencies"
  }
}

run "examples_apply" {
  command = apply

  variables {
    diagnostic_settings = run.setup.diagnostic_settings
    enable_telemetry    = false
    location            = run.setup.azurerm_resource_group.location
    name                = run.setup.naming.kusto_cluster.name_unique
    private_endpoints   = run.setup.private_endpoints
    resource_group_name = run.setup.azurerm_resource_group.name

    databases = {
      crm = {
        name               = "crm"
        hot_cache_period   = "P30D"
        soft_delete_period = "P30D"
      }
    }

    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }
  }

  assert {
    condition     = azurerm_kusto_cluster.this.name == run.setup.naming.kusto_cluster.name_unique
    error_message = "Cluster name does not match the input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.resource_group_name == run.setup.azurerm_resource_group.name
    error_message = "Resource group name does not match the input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.location == run.setup.azurerm_resource_group.location
    error_message = "Resource group location does not match the input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.sku[0] == var.sku
    error_message = "Sku does not match the input variable."
  }
}