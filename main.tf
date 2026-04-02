terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

provider "random" {}

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

module "database" {
  source              = "./modules/database"
  location            = var.location
  environment         = var.environment
  project             = var.project
  resource_group_name = module.networking.resource_group_name
  tenant_id           = var.tenant_id
}
