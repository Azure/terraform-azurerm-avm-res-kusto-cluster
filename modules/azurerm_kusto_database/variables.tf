variable "cluster_name" {
  type        = string
  description = "(Required) Specifies the name of the Kusto Cluster this database will be added to. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The location where the Kusto Database should be created. Changing this forces a new resource to be created."
}

variable "name" {
  type        = string
  description = "(Required) The name of the Kusto Database to create. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the Resource Group where the Kusto Database should exist. Changing this forces a new resource to be created."
}

variable "hot_cache_period" {
  type        = string
  default     = null
  description = "(Optional) The time the data that should be kept in cache for fast queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan."
}

variable "soft_delete_period" {
  type        = string
  default     = null
  description = "(Optional) The time the data should be kept before it stops being accessible to queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan."
}
