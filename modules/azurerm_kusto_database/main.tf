resource "azurerm_kusto_database" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name

  hot_cache_period   = var.hot_cache_period
  soft_delete_period = var.soft_delete_period
}