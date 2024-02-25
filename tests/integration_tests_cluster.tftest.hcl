provider "azurerm" {
  features {}
}

run "setup" {
  module {
    source = "./tests/setup/intergation_tests"
  }
}

run "cluster" {
  command = apply

  variables {
    name                = run.setup.naming.kusto_cluster.name_unique
    resource_group_name = run.setup.azurerm_resource_group.name
    location            = run.setup.azurerm_resource_group.location
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }
  }

  assert {
    condition = azurerm_kusto_cluster.this.name == run.setup.naming.kusto_cluster.name_unique
    error_message = "Cluster name does not match the input variable."
  }

  assert {
    condition = azurerm_kusto_cluster.this.resource_group_name == run.setup.azurerm_resource_group.name
    error_message = "Resource group name does not match the input variable."
  }

  assert {
    condition = azurerm_kusto_cluster.this.location == run.setup.azurerm_resource_group.location
    error_message = "Resource group location does not match the input variable."
  }

  assert {
    condition = azurerm_kusto_cluster.this.sku[0] == var.sku
    error_message = "Sku does not match the input variable."
  }
}