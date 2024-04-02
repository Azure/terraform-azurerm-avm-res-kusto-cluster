output "id" {
  value       = azurerm_kusto_database_principal_assignment.this.id
  description = "The ID of the Kusto Cluster Principal Assignment."
}
output "principal_name" {
  value       = azurerm_kusto_database_principal_assignment.this.principal_name
  description = "The name of the principal."
}
output "cluster_name" {
  value       = azurerm_kusto_database_principal_assignment.this.cluster_name
  description = "The name of the cluster."
}
output "tenant_name" {
  value       = azurerm_kusto_database_principal_assignment.this.tenant_name
  description = "The name of the tenant."
}
output "name" {
  value       = azurerm_kusto_database_principal_assignment.this.name
  description = "The name of the Kusto cluster principal assignment."
}