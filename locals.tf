# Helps to combine data, easier debug and remove complexity in the main resource.

locals {
  resource_groups_list = [
    for index, resource_group in var.resource_groups : {
      # Most will try and use key/value resource_group first, then try applicable defaults and then null as a last resort.

      ### Basic

      index    = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      location = try(coalesce(resource_group.location, try(var.defaults.location, null)), null)
      name     = resource_group.name
      # Merges resource_group or default tags with required tags.
      tags = merge(
        # Count resource_group tags, if greater than 0 use them, otherwise try defaults tags if they exist, if not use a blank map. 
        length(resource_group.tags) > 0 ? resource_group.tags : try(var.defaults.tags, {}),
        try(var.required.tags, {})
      )

      ###### Sub-resource & Additional Modules

      role_assignments = resource_group.role_assignments
    }
  ]

  # Used to create unique id for for_each loops, as just using the name may not be unique.
  resource_groups = {
    for resource_group in local.resource_groups_list : resource_group.name => resource_group
  }

  ### Sub-resource & Additional Modules

  # Iterate local.resource_groups_list and role_assignments to build a flat list of role_assignments with proper scope and unique IDs.
  role_assignments = flatten([
    for resource_group in local.resource_groups_list : [
      for role_assignment in resource_group.role_assignments : merge(role_assignment, {
        scope = azurerm_resource_group.this[resource_group.name].id
        unique_for_each_id = format(
          "%s>%s>%s",
          resource_group.name,
          role_assignment.principal_id,
          coalesce(try(role_assignment.role_definition_name, null), try(role_assignment.role_definition_id, null))
        )
      })
    ] if length(resource_group.role_assignments) > 0 # Filters out any empty role assignment lists.
  ])
}
