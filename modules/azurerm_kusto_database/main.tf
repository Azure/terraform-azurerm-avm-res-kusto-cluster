resource "azurerm_kusto_database" "this" {
  cluster_name        = var.cluster_name
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  hot_cache_period    = var.hot_cache_period
  soft_delete_period  = var.soft_delete_period
}