module "kusto_database_principal_assignment" {
  # tflint-ignore: required_module_source_tffr1
  source   = "./modules/azurerm_kusto_database_principal_assignment"
  for_each = var.kusto_database_principal_assignment

  database_name       = each.value.database_name
  cluster_name        = azurerm_kusto_cluster.this.name
  name                = each.value.name
  principal_id        = each.value.principal_id
  principal_type      = each.value.principal_type
  resource_group_name = azurerm_kusto_cluster.this.resource_group_name
  role                = each.value.role
  tenant_id           = each.value.tenant_id
}