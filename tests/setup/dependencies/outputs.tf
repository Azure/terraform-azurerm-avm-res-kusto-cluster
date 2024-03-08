
output "azurerm_log_analytics_workspace" {
  value = {
    # Filter output to remove the sensitive keys
    id           = azurerm_log_analytics_workspace.this.id
    workspace_id = azurerm_log_analytics_workspace.this.workspace_id
  }
}

output "azurerm_resource_group" {
  value = azurerm_resource_group.this
}

output "azurerm_subnet" {
  value = azurerm_subnet.this
}

output "azurerm_storage_account" {
  value = {
    id = azurerm_storage_account.this.id
  }
}

output "azurerm_virtual_network" {
  value = azurerm_virtual_network.this
}

output "client_config" {
  value = {
    client_id       = data.azurerm_client_config.current.client_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    object_id       = data.azurerm_client_config.current.object_id
    principal_type  = "App"
  }
}

output "diagnostic_settings" {
  value = {
    operations = {
      name                        = "Operational logs"
      workspace_resource_id       = azurerm_log_analytics_workspace.this.id
      storage_account_resource_id = azurerm_storage_account.this.id
    }
  }
}

output "naming" {
  value = module.naming
}

output "private_endpoints" {
  value = {
    pip1 = {
      subnet_resource_id = azurerm_subnet.this.id
    }
  }
}
