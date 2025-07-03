terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3"
}

# example allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "example" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
  tags = {
    module = "kusto-cluster"
  }
}

resource "azurerm_virtual_network" "example" {
  location            = azurerm_resource_group.example.location
  name                = "example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_log_analytics_workspace" "example" {
  location            = azurerm_resource_group.example.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.example.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}

resource "azurerm_storage_account" "example" {
  account_replication_type = "ZRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.example.location
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.example.name
}

module "kusto" {
  source = "../../"

  location            = azurerm_resource_group.example.location
  name                = module.naming.kusto_cluster.name_unique
  resource_group_name = azurerm_resource_group.example.name
  sku = {
    name     = "Dev(No SLA)_Standard_D11_v2"
    capacity = 1
  }
  allowed_fqdns     = var.allowed_fqdns
  allowed_ip_ranges = var.allowed_ip_ranges
  auto_stop_enabled = var.auto_stop_enabled
  databases = {
    crm = {
      name               = "crm"
      hot_cache_period   = "P30D"
      soft_delete_period = "P30D"
    }
  }
  disk_encryption_enabled             = var.disk_encryption_enabled
  double_encryption_enabled           = var.double_encryption_enabled
  enable_telemetry                    = false # Disabled for testing. 
  kusto_cluster_principal_assignments = var.kusto_cluster_principal_assignments
  kusto_database_principal_assignment = var.kusto_database_principal_assignment
  language_extensions                 = var.language_extensions
  lock                                = var.lock
  managed_identities = {
    type = "SystemAssigned"
  }
  outbound_network_access_restricted = var.outbound_network_access_restricted
  # Commented as it is impacted by a bug that prevent the deployment to be idempotent https://github.com/Azure/azure-rest-api-specs/issues/22400
  # diagnostic_settings = {
  #   operations = {
  #     name                        = "Operational logs"
  #     workspace_resource_id       = azurerm_log_analytics_workspace.example.id
  #     storage_account_resource_id = azurerm_storage_account.example.id
  #   }
  # }
  private_endpoints = {
    pip1 = {
      subnet_resource_id = azurerm_subnet.example.id
    }
  }
  public_ip_type                = var.public_ip_type
  public_network_access_enabled = var.public_network_access_enabled
  purge_enabled                 = var.purge_enabled
  streaming_ingestion_enabled   = var.streaming_ingestion_enabled
  tags                          = var.tags
  trusted_external_tenants      = var.trusted_external_tenants
  virtual_network_configuration = var.virtual_network_configuration
  zones                         = var.zones
}

# Call the kusto_database submodule directlty and reference the existing kusto cluster
module "kusto_database" {
  source = "../..//modules/azurerm_kusto_database"

  cluster_name        = module.kusto.resource.name
  location            = module.kusto.resource.location
  name                = module.naming.kusto_database.name_unique
  resource_group_name = module.kusto.resource.resource_group_name
  hot_cache_period    = "P455D"
  soft_delete_period  = "P1D"
}