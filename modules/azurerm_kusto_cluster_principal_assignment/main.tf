resource "azurerm_kusto_cluster_principal_assignment" "this" {
  cluster_name        = var.cluster_name
  name                = var.name
  principal_id        = var.principal_id
  principal_type      = var.principal_type
  resource_group_name = var.resource_group_name
  role                = var.role
  tenant_id           = var.tenant_id
}