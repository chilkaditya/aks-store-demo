terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks1" {
  name                = "tf-aks1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "tf-aks1"

  default_node_pool {
    name       = "default"
    vm_size    = "standard_a2_v2"
    enable_auto_scaling = true
    min_count  = 2
    max_count  = 3
    node_count = 2
    max_pods   = 30
  }

  identity {
    type = "SystemAssigned"
  }

  # tags = {
  #   Environment = "Production"
  # }
}