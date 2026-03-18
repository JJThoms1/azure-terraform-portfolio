terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

module "networking" {
  source      = "./modules/networking"
  location    = var.location
  environment = var.environment
  project     = var.project
}

module "compute" {
  source              = "./modules/compute"
  location            = var.location
  environment         = var.environment
  project             = var.project
  resource_group_name = module.networking.resource_group_name
  public_subnet_id    = module.networking.public_subnet_id
  app_subnet_id       = module.networking.app_subnet_id
}
