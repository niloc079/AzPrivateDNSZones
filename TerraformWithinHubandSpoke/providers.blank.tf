# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.70.0"
    }
  }
}

# Configure the Microsoft Azure Provider
#provider "azurerm" {
#  features {}
#}

#0
#Default
provider "azurerm" {
  features {}
  #alias = "Default"
  tenant_id       = "?????"
  subscription_id = "?????"
}


#1
#hub
provider "azurerm" {
  features {}
  alias = "hub"
  tenant_id       = "?????"
  subscription_id = "?????"
}

#2
#production
provider "azurerm" {
  features {}
  alias = "prd"
  tenant_id       = "?????"
  subscription_id = "?????"
}

#3
#staging
provider "azurerm" {
  features {}
  alias = "stg"
  tenant_id       = "?????"
  subscription_id = "?????"
}

#4
#dev
provider "azurerm" {
  features {}
  alias = "dev"
  tenant_id       = "?????"
  subscription_id = "?????"
}

#5
#sandbox
provider "azurerm" {
  features {}
  alias = "sbx"
  tenant_id       = "?????"
  subscription_id = "?????"
}

#6
#management
provider "azurerm" {
  features {}
  alias = "mgt"
  tenant_id       = "?????"
  subscription_id = "?????"
}

#7
#identity
provider "azurerm" {
  features {}
  alias = "idp"
  tenant_id       = "?????"
  subscription_id = "?????"
}