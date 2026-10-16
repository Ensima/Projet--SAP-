terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # Permet "terraform destroy" même si une ressource créée à la main traîne dans le groupe.
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}
