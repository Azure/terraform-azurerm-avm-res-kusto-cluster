variable "name" {
  type        = string
  description = "(Required) The name of the Kusto Database to create. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The location where the Kusto Database should be created. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the Resource Group where the Kusto Database should exist. Changing this forces a new resource to be created."
}

variable "cluster_name" {
  type        = string
  description = "(Required) Specifies the name of the Kusto Cluster this database will be added to. Changing this forces a new resource to be created."
}

variable "hot_cache_period" {
  type        = string
  description = "(Optional) The time the data that should be kept in cache for fast queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan."
  default     = null

  # validation {
  #   condition     = var.hot_cache_period == null ? true : can(regex("^P(?:d+Y)?(?:d+M)?(?:d+D)?(?:T(?:d+H)?(?:d+M)?(?:d+(?:.d+)?S)?)?$", var.hot_cache_period))
  #   error_message = <<-ERROR
  #   Set an ISO 8601 timespan that matches the regex:

  #   ^P(?:d+Y)?(?:d+M)?(?:d+D)?(?:T(?:d+H)?(?:d+M)?(?:d+(?:.d+)?S)?)?$

  #   Explanation:

  #   ^ asserts the start of the string.
  #   P indicates the start of the period.
  #   (?:d+Y)? matches an optional number of years.
  #   (?:d+M)? matches an optional number of months.
  #   (?:d+D)? matches an optional number of days.
  #   (?:T(?:d+H)?(?:d+M)?(?:d+(?:.d+)?S)?)? matches an optional time component, starting with 'T', with optional hours, minutes, and seconds.
  #   $ asserts the end of the string.
  #   This regex pattern covers various formats of ISO 8601 time spans, such as:

  #   P3Y6M4DT12H30M5S (3 years, 6 months, 4 days, 12 hours, 30 minutes, and 5 seconds)
  #   PT15M (15 minutes)
  #   P1D (1 day)
  #   P2W (2 weeks)
  #   P1Y2M3DT4H5M6S (1 year, 2 months, 3 days, 4 hours, 5 minutes, and 6 seconds)
  #   PT10H (10 hours)

  #   ERROR
  # }
}

variable "soft_delete_period" {
  type        = string
  description = "(Optional) The time the data should be kept before it stops being accessible to queries as ISO 8601 timespan. Default is unlimited. For more information see: ISO 8601 Timespan."
  default     = null

  # validation {
  #   condition     = var.soft_delete_period == null ? true : can(regex("^P(?!.*\\d[,.]\\d.*\\d)(?!$)(\\d+(?:[,.]\\d+)?Y)?(\\d+(?:[,.]\\d+)?M)?(\\d+(?:[,.]\\d+)?W)?(\\d+(?:[,.]\\d+)?D)?(T(?=\\d)(\\d+(?:[,.]\\d+)?H)?(\\d+(?:[,.]\\d+)?M)?(\\d+(?:[,.]\\d+)?S)?)?$", var.soft_delete_period))
  #   error_message = <<-ERROR
  #   Set an ISO 8601 timespan that matches the regex:

  #   ^P(([0-9]+Y)?(([0]\d|1[0-2])+M)?([0-9]+D)?)$
  #   ^P(([0-9]+Y)?(([123456789]|1[02])M)?([0-9]+W)?(([123456789]|[12][0-9]|3[01])D)?)$
  #   Explanation:

  #   ^
  #   P
  #   (
  #     ([0-9]+Y)?
  #     (([123456789]|1[02])M)?             # 1 to 12 month
  #     ([0-9]+W)?                          # n number of weeks
  #     (([123456789]|[12][0-9]|3[01])D)?   # 1 to 31 day(s)
  #   )

  #   ^ asserts the start of the string.
  #   P indicates the start of the period.
  #   (?:d+Y)? matches an optional number of years.
  #   (?:d+M)? matches an optional number of months.
  #   (?:d+D)? matches an optional number of days.
  #   (?:T(?:d+H)?(?:d+M)?(?:d+(?:.d+)?S)?)? matches an optional time component, starting with 'T', with optional hours, minutes, and seconds.
  #   $ asserts the end of the string.
  #   This regex pattern covers various formats of ISO 8601 time spans, such as:

  #   P3Y6M4DT12H30M5S (3 years, 6 months, 4 days, 12 hours, 30 minutes, and 5 seconds)
  #   PT15M (15 minutes)
  #   P1D (1 day)
  #   P2W (2 weeks)
  #   P1Y2M3DT4H5M6S (1 year, 2 months, 3 days, 4 hours, 5 minutes, and 6 seconds)
  #   PT10H (10 hours)

  #   ERROR
  # }
}