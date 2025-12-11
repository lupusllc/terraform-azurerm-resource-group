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

resource "azurerm_resource_group" "this" {
  for_each = local.resource_groups

  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}

##### Role Assignments

module "lupus_az_role_assignment" {
  source  = "lupusllc/role-assignment/azurerm" # https://registry.terraform.io/modules/lupusllc/storage-account/azurerm/latest
  version = "0.0.1"
  for_each = local.role_assignments

  role_assignments = [for role in each.value : merge(role, {
    scope = azurerm_resource_group.this[each.key].id
    # Create a unique ID for each role assignment to avoid collisions, we can't use scope since it isn't known a new resource.
    unique_for_each_id = format("%s>%s>%s", each.key, role.principal_id, coalesce(try(role.role_definition_name, null), try(role.role_definition_id, null)))
  })]
}
