module "kusto_cluster_principal_assignment" {
  source   = "./modules/azurerm_kusto_cluster_principal_assignment"
  for_each = var.kusto_cluster_principal_assignments

  cluster_name        = azurerm_kusto_cluster.this.name
  name                = each.value.name
  principal_id        = each.value.principal_id
  principal_type      = each.value.principal_type
  resource_group_name = azurerm_kusto_cluster.this.resource_group_name
  role                = each.value.role
  tenant_id           = each.value.tenant_id
}