# Tests

## Unit tests

Run from the repository root with PowerShell and Avm.Authoring:

```powershell
Import-Module Avm.Authoring
avm test unit
```

The four files under `tests/unit` contain 23 provider-mocked runs. They do not
deploy Azure resources or send telemetry.

## Integration tests

The two files under `tests/integration` contain four real-provider runs.
`examples_apply.tftest.hcl` applies the dependency fixture, then applies the
cluster. `examples_plan.tftest.hcl` also applies the fixture, then only plans the
cluster. Both cluster runs retain the name, resource-group, location and SKU
assertions.

Run only against an approved non-production subscription and identity:

```powershell
Import-Module Avm.Authoring
avm test integration
```

These suites are self-contained: both cluster runs bind the CRM database settings
previously supplied by `examples/cluster_with_databases/terraform.tfvars`, so
managed CI needs no `-var-file`. Every required cluster input is bound in each run;
the fixture supplies the names and location using the unchanged pinned naming and
cached-regions modules. Each fixture
creates a resource group, virtual network, subnet, Log Analytics workspace and
storage account. The apply suite additionally creates the cluster, CRM database,
diagnostic setting and private endpoint. Both cluster runs explicitly disable
telemetry; the fixtures and their utility dependencies contain no telemetry.

The identity must already be approved to create, read and delete these resources
in the selected subscription. Resource providers, quota and the chosen region's
support for `Dev(No SLA)_Standard_D11_v2` must be available. AzureRM v4 can
auto-register additional resource providers; review the effective
`ARM_RESOURCE_PROVIDER_REGISTRATIONS` setting without granting more access.
No subscription or
identity is hardcoded, and these tests must not use customer state or existing
customer resources. Terraform test cleanup destroys its own deployments in reverse
run order; interrupted cleanup must be investigated before another run.

Protected CI integration needs a fresh review of the exact commit, subscription,
identity and cleanup scope before approval. The plan suite is not an offline
test: its setup still deploys Azure resources.