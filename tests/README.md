# Tests

## Unit tests


To execute the unit tests
```bash
# all
terraform test --verbose

# Kusto cluster
terraform test --verbose -filter=tests/unit_tests_cluster.tftest.hcl

# cluster_principal_assignment
terraform test --verbose -filter=tests/unit_tests_cluster_principal_assignment.tftest.hcl

# kusto_database_principal_assignment
terraform test --verbose -filter=tests/unit_tests_database_principal_assignment.tftest.hcl
```

## Integration tests

Note Integration tests are deploying resources in real Azure subscription and will take time to complete. 

```bash
terraform test --verbose -filter=tests/integration_tests_cluster.tftest.hcl

```
