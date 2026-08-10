module "kusto_database" {
  # tflint-ignore: required_module_source_tffr1
  source   = "./modules/azurerm_kusto_database"
  for_each = var.databases

  cluster_name        = each.value.cluster_name == null ? azurerm_kusto_cluster.this.name : each.value.cluster_name
  location            = each.value.location == null ? azurerm_kusto_cluster.this.location : each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name == null ? azurerm_kusto_cluster.this.resource_group_name : each.value.resource_group_name
  hot_cache_period    = each.value.hot_cache_period
  soft_delete_period  = each.value.soft_delete_period
}
