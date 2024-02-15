mock_provider "azurerm" {
  source = "tests/mock_data"
}

run "setup_dependencies" {
  module {
    source = "./tests/setup"
  }
}

run "validation_rules_required_pass" {

  variables {
    name                = "demo"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }

    databases = {
      crm = {
        name = "db-crm"
      }
      sales = {
        name = "db-sales"
      }
    }

    kusto_database_principal_assignment = {
      crm = {
        database_name       = "db-crm"
        name                = "KustoPrincipalAssignment"
        resource_group_name = run.setup_dependencies.azurerm_resource_group.name
        principal_id        = run.setup_dependencies.client_config.client_id
        tenant_id           = run.setup_dependencies.client_config.tenant_id
        principal_type      = run.setup_dependencies.client_config.principal_type
        role                = "Viewer"
      }
    }
  }

  assert {
    condition = alltrue(
      [
        for k in keys(var.kusto_database_principal_assignment) :
        var.kusto_database_principal_assignment[k].name == module.kusto_database_principal_assignment[k].name
      ]
    )
    error_message = format("The name of the Kusto cluster principal assignment does not equals to the input variable. %s", join(", ",
      [
        for k in keys(var.kusto_database_principal_assignment) : format("'%s -> (should be) [%s], got [%s]'", k, var.kusto_database_principal_assignment[k].name, module.kusto_database_principal_assignment[k].name)
        if var.kusto_database_principal_assignment[k].name != module.kusto_database_principal_assignment[k].name
      ]
      )
    )
  }
  assert {
    condition = alltrue(
      [
        for k in keys(var.kusto_database_principal_assignment) :
        azurerm_kusto_cluster.this.name == module.kusto_database_principal_assignment[k].cluster_name
      ]
    )
    error_message = format("The name of the Kusto cluster does not equals to the input variable. %s", join(", ",
      [
        for k in keys(var.kusto_database_principal_assignment) : format("'%s -> (should be) [%s], got [%s]'", k, azurerm_kusto_cluster.this.name, module.kusto_database_principal_assignment[k].cluster_name)
        if azurerm_kusto_cluster.this.name != module.kusto_database_principal_assignment[k].cluster_name
      ]
      )
    )
  }

}

run "validation_rules_fails" {
  command = plan

  variables {
    name                = "demo"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }

    databases = {
      crm = {
        name = "db-crm"
      }
      sales = {
        name = "db-sales"
      }
    }

    kusto_database_principal_assignment = {
      crm = {
        database_name       = "db-crm"
        name                = "KustoPrincipalAssignment"
        resource_group_name = run.setup_dependencies.azurerm_resource_group.name
        principal_id        = run.setup_dependencies.client_config.client_id
        tenant_id           = run.setup_dependencies.client_config.tenant_id
        principal_type      = "Fake"
        role                = "Unknown"
      }
      unknown = {
        database_name       = "unknown"
        name                = "KustoPrincipalAssignment"
        resource_group_name = run.setup_dependencies.azurerm_resource_group.name
        principal_id        = run.setup_dependencies.client_config.client_id
        tenant_id           = run.setup_dependencies.client_config.tenant_id
        principal_type      = "Group"
        role                = "Monitor"
      }
    }
  }

  expect_failures = [
    var.kusto_database_principal_assignment
  ]
}