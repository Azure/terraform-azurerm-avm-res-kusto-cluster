# Tests

To execute all tests
```bash
# all
terraform test
```

## Unit tests

To execute the unit tests
```bash
# all
terraform test --verbose

# Kusto cluster
terraform test --verbose -filter=tests/unit_tests_cluster_databases.tftest.hcl

# cluster_principal_assignment
terraform test --verbose -filter=tests/unit_tests_cluster_principal_assignment.tftest.hcl

# kusto_database_principal_assignment
terraform test --verbose -filter=tests/unit_tests_database_principal_assignment.tftest.hcl
```

## Integration tests

Note Integration tests are deploying resources in real Azure subscription and will take time to complete. 

Testing integration test with plan mode
```bash
# dependencies are deployed, the base module only has a plan
terraform test --verbose -filter=tests/examples_plan.tftest.hcl -var-file examples/cluster_with_databases/terraform.tfvars
```

Testing integration test with apply mode
```bash
# dependencies are deployed, the base module only has a plan
terraform test --verbose -filter=tests/examples_apply.tftest.hcl -var-file examples/cluster_with_databases/terraform.tfvars
```