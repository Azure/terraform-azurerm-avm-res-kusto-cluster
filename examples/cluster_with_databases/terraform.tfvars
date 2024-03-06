name                = "kusto"
resource_group_name = "rg-kusto"
sku = {
  name     = "Dev(No SLA)_Standard_D11_v2"
  capacity = 1
}

databases = {
  crm = {
    name               = "crm"
    hot_cache_period   = "P30D"
    soft_delete_period = "P30D"
  }
}