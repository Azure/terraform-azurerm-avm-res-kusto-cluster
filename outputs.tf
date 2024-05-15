output "data_ingestion_uri" {
  description = "The Kusto Cluster URI to be used for data ingestion."
  value       = azurerm_kusto_cluster.this.data_ingestion_uri
}

output "id" {
  description = "The Kusto Cluster ID."
  value       = azurerm_kusto_cluster.this.id
}

output "identity" {
  description = <<-DESCRIPTION
  An identity block exports the following:

  principal_id - The Principal ID associated with this System Assigned Managed Service Identity.

  tenant_id - The Tenant ID associated with this System Assigned Managed Service Identity.
  DESCRIPTION
  value       = azurerm_kusto_cluster.this.identity
}

output "private_endpoints" {
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
  value       = azurerm_private_endpoint.this
}

# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "resource" {
  description = "This is the full output for the resource."
  value       = azurerm_kusto_cluster.this
}

output "resource_id" {
  description = "The Kusto Cluster resource ID."
  value       = azurerm_kusto_cluster.this.id
}

output "uri" {
  description = "The FQDN of the Azure Kusto Cluster."
  value       = azurerm_kusto_cluster.this.uri
}
