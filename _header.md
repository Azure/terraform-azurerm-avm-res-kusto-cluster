# terraform-azurerm-avm-res-kusto-cluster

Manages a Kusto (also known as Azure Data Explorer) Cluster and databases

## Upgrade notes

Requires Terraform 1.8 or later and AzureRM `>= 4.45, < 5.0`. The existing
`language_extensions` string values are preserved and translated into v4
`language_extension` blocks. Primary resource addresses are unchanged. The
obsolete `random_id.telem` and resource-group telemetry deployment are forgotten
with `destroy = false`; existing telemetry deployment objects are retained.

Private endpoints now honor role assignments, lock notes, member names, and the
DNS management toggle. Endpoint locks inherit the cluster lock unless overridden;
set an endpoint's `lock.kind` to `None` to opt out. Use `lock = null` to disable the
cluster lock. Endpoint tags inherit `tags` unless an endpoint supplies its own map.
The legacy AzureRM `private_endpoints[*].resource_group_name` still takes a name,
not a resource ID.

For Azure deployments, leave `ip_configurations` empty: Azure Data Explorer
[currently supports dynamic private IP allocation only](https://learn.microsoft.com/azure/data-explorer/security-network-private-endpoint-create).
The standard member-name fields are forwarded without implying service support
for static allocation. Supply all DNS zones required by the cluster, including its
ingestion storage zones, when managing DNS here.

`private_endpoints_manage_dns_zone_group = false` leaves DNS zone groups to an
external manager and ignores changes to them. The default `true` retains existing
endpoint addresses. When changing this setting on deployed endpoints, add a
consumer-side `moved` block for each existing endpoint to avoid replacement:

```hcl
moved {
  from = module.kusto.azurerm_private_endpoint.this["primary"]
  to   = module.kusto.azurerm_private_endpoint.this_unmanaged_dns_zone_groups["primary"]
}
```

Reverse the move when returning to module-managed DNS. Review the plan before
applying; changing the toggle without migrating addresses replaces the endpoints.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
> 
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
> 
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.
