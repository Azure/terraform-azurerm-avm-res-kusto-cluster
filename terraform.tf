terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.103.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
  }
}
