mock_provider "azurerm" {
  alias  = "unit"
  source = "tests/setup/mock_data"
}

mock_provider "azapi" {
  alias  = "unit"
  source = "tests/setup/mock_azapi"
}

mock_provider "modtm" {
  alias  = "unit"
  source = "tests/setup/mock_modtm"
}

mock_provider "random" {
  alias  = "unit"
  source = "tests/setup/mock_random"
}

mock_provider "local" {
  alias = "unit"
}

run "setup_dependencies" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
    local   = local.unit
    random  = random.unit
  }

  module {
    source = "./tests/setup/dependencies"
  }
}

run "validation_rules_required_pass" {
  command = apply

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
    modtm   = modtm.unit
    random  = random.unit
  }

  variables {
    name                = "demo"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }

    kusto_cluster_principal_assignments = {
      rbac1 = {
        name                = "KustoPrincipalAssignment"
        resource_group_name = run.setup_dependencies.azurerm_resource_group.name
        principal_id        = run.setup_dependencies.client_config.client_id
        tenant_id           = run.setup_dependencies.client_config.tenant_id
        principal_type      = run.setup_dependencies.client_config.principal_type
        role                = "AllDatabasesAdmin"
      }
    }
  }

  assert {
    condition     = alltrue([for assignment in module.kusto_cluster_principal_assignment : assignment.resource_id == assignment.id && assignment.resource_id != ""])
    error_message = "Each cluster principal assignment must expose its resource ID and retain the id output."
  }

  assert {
    condition = alltrue(
      [
        for k in keys(var.kusto_cluster_principal_assignments) :
        var.kusto_cluster_principal_assignments[k].name == module.kusto_cluster_principal_assignment[k].name
      ]
    )
    error_message = format("The name of the Kusto cluster principal assignment does not equals to the input variable. %s", join(", ",
      [
        for k in keys(var.kusto_cluster_principal_assignments) : format("'%s -> (should be) [%s], got [%s]'", k, var.kusto_cluster_principal_assignments[k].name, module.kusto_cluster_principal_assignment[k].name)
        if var.kusto_cluster_principal_assignments[k].name != module.kusto_cluster_principal_assignment[k].name
      ]
      )
    )
  }
  assert {
    condition = alltrue(
      [
        for k in keys(var.kusto_cluster_principal_assignments) :
        azurerm_kusto_cluster.this.name == module.kusto_cluster_principal_assignment[k].cluster_name
      ]
    )
    error_message = format("The name of the Kusto cluster does not equals to the input variable. %s", join(", ",
      [
        for k in keys(var.kusto_cluster_principal_assignments) : format("'%s -> (should be) [%s], got [%s]'", k, azurerm_kusto_cluster.this.name, module.kusto_cluster_principal_assignment[k].cluster_name)
        if azurerm_kusto_cluster.this.name != module.kusto_cluster_principal_assignment[k].cluster_name
      ]
      )
    )
  }

}

run "validation_rules_fails" {
  command = plan

  providers = {
    azapi   = azapi.unit
    azurerm = azurerm.unit
    modtm   = modtm.unit
    random  = random.unit
  }

  variables {
    name                = "demo"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }

    kusto_cluster_principal_assignments = {
      rbac1 = {
        name                = "KustoPrincipalAssignment"
        resource_group_name = run.setup_dependencies.azurerm_resource_group.name
        principal_id        = run.setup_dependencies.client_config.client_id
        tenant_id           = run.setup_dependencies.client_config.tenant_id
        principal_type      = "Fake"
        role                = "Unknown"
      }
    }
  }

  expect_failures = [
    var.kusto_cluster_principal_assignments
  ]
}