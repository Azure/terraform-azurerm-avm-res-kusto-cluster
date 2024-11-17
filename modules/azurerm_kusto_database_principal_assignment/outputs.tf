output "cluster_name" {
  description = "The name of the cluster."
  value       = azurerm_kusto_database_principal_assignment.this.cluster_name
}

output "id" {
  description = "The ID of the Kusto Cluster Principal Assignment."
  value       = azurerm_kusto_database_principal_assignment.this.id
}

output "name" {
  description = "The name of the Kusto cluster principal assignment."
  value       = azurerm_kusto_database_principal_assignment.this.name
}

output "principal_name" {
  description = "The name of the principal."
  value       = azurerm_kusto_database_principal_assignment.this.principal_name
}

output "tenant_name" {
  description = "The name of the tenant."
  value       = azurerm_kusto_database_principal_assignment.this.tenant_name
}
