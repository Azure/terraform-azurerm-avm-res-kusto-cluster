output "id" {
  value       = azurerm_kusto_database.this.id
  description = "The Kusto Cluster ID."
}
output "name" {
  value       = azurerm_kusto_database.this.name
  description = "The name of the database."
}

output "size" {
  value       = azurerm_kusto_database.this.size
  description = "The size of the database in bytes."
}

output "cluster_name" {
  value       = azurerm_kusto_database.this.cluster_name
  description = "The name of the Kusto Cluster"
}

output "resource_group_name" {
  value       = azurerm_kusto_database.this.resource_group_name
  description = "The Resource Group where the Kusto Database exist."
}