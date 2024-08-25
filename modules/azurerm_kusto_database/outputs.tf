output "cluster_name" {
  description = "The name of the Kusto Cluster"
  value       = azurerm_kusto_database.this.cluster_name
}

output "id" {
  description = "The Kusto Cluster ID."
  value       = azurerm_kusto_database.this.id
}

output "name" {
  description = "The name of the database."
  value       = azurerm_kusto_database.this.name
}

output "resource_group_name" {
  description = "The Resource Group where the Kusto Database exist."
  value       = azurerm_kusto_database.this.resource_group_name
}

output "size" {
  description = "The size of the database in bytes."
  value       = azurerm_kusto_database.this.size
}
