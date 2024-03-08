# Example with database, private endpoint and diagnostic provfile

This example shows how to deploy the module with a private endpoint connection.
We have also included kusto databases and a diagnostic profile.

To run that test

```shell
terraform -chdir=examples/cluster_with_databases init

terraform -chdir=examples/cluster_with_databases plan -var-file terraform.tfvars

terraform -chdir=examples/cluster_with_databases apply -var-file terraform.tfvars
```
