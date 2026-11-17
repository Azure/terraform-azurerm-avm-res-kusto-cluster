# terraform-azurerm-avm-res-kusto-cluster

Manages a Kusto (also known as Azure Data Explorer) Cluster and databases

## Upgrade notes

Requires Terraform 1.11 or later and AzureRM `>= 4.45, < 5.0`. The existing
`language_extensions` string values are preserved and translated into v4
`language_extension` blocks. Primary resource addresses are unchanged. The
candidate marks `modtm_telemetry.telemetry`, `random_uuid.telemetry`,
`random_id.telem`, and `azurerm_resource_group_template_deployment.telemetry`
with `destroy = false`. This is static source evidence only; no authentic v0.2.0
saved-state upgrade plan was available, so no real-state no-destroy result is claimed.

Private endpoints now honor role assignments, lock notes, member names, and the
DNS management toggle. Endpoint locks inherit the cluster lock unless overridden;
set an endpoint's `lock.kind` to `None` to opt out. A module-level lock must use
`CanNotDelete` or `ReadOnly`; set the module-level `lock = null` to disable it.
Endpoint tags inherit `tags` unless an endpoint supplies its own map. The legacy
AzureRM `private_endpoints[*].resource_group_name` still takes a name, not a resource ID.

For Azure deployments, leave `ip_configurations` empty: Azure Data Explorer
[currently supports dynamic private IP allocation only](https://learn.microsoft.com/azure/data-explorer/security-network-private-endpoint-create).
The standard member-name fields are forwarded without implying service support
for static allocation. Supply all DNS zones required by the cluster, including its
ingestion storage zones, when managing DNS here.

`private_endpoints_manage_dns_zone_group` is new; v0.2.0 did not expose an opt-out.
Its default `true` retains the existing managed endpoint address. Setting it to
`false` leaves DNS zone groups to an external manager and ignores changes to them.
For each deployed endpoint map key, migrate the address using the caller's full
module prefix (including any nested module path):

`module.<caller-prefix>.azurerm_private_endpoint.this["<key>"]` → `module.<caller-prefix>.azurerm_private_endpoint.this_unmanaged_dns_zone_groups["<key>"]`

Reverse that per-key address move when returning to module-managed DNS. No state move
is needed when retaining the default `true`. Changing the setting without moving
each instance can plan endpoint replacement; review the consumer plan before applying.
This address mapping is static review; no authentic v0.2.0 saved-state upgrade plan
was available.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
> 
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
> 
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.
