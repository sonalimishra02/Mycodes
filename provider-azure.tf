terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.80"
    }
  }

  backend "azurerm" {
    resource_group_name  = "azurerm_resource_group.terraform-lab.name"
    storage_account_name = "terraformlab1"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
    access_key = "CKMGA4KPpXTfH+3RzItVSHOHpdP5IjowZLL0Lyu/R+vmbwrenFrGGmYZ/4FhMrUVf0vDv/8U1Fya/PX6d1DVEA=="
  }
}

provider "azurerm" {
  subscription_id = "dbb9a982-2a02-4d33-b4f4-7fab3b1bb5a7"
  features {}
}
