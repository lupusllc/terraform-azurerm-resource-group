### Requirements:

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54.0" # Tested on this provider version, but will allow future patch versions.
    }
  }
  required_version = "~> 1.14.0" # Tested on this Terraform CLI version, but will allow future patch versions.
}

### Data:

### Resources:

###### Main

resource "azurerm_resource_group" "this" {
  for_each = local.resource_groups

  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}

###### Sub-resource & Additional Modules

module "lupus_az_role_assignment" {
  depends_on = [azurerm_resource_group.this] # Ensures resource group exists before role assignments are created.
  source  = "lupusllc/role-assignment/azurerm" # https://registry.terraform.io/modules/lupusllc/storage-account/azurerm/latest
  version = "0.0.2"

  ### Basic

  role_assignments = local.role_assignments
}
