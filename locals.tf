# Helps to combine data, easier debug and remove complexity in the main resource.

locals {
  resource_groups = {
    for index, settings in var.resource_groups : settings.name => {
      # Most will try and use key/value settings first, then try applicable defaults and then null as a last resort.

      ### Basic

      index    = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      location = try(coalesce(settings.location, try(var.defaults.location, null)), null)
      # Merges settings or default tags with required tags.
      tags = merge(
        # Count settings tags, if greater than 0 use them, otherwise try defaults tags if they exist, if not use a blank map. 
        length(settings.tags) > 0 ? settings.tags : try(var.defaults.tags, {}),
        try(var.required.tags, {})
      )

      ###### Role Assignments

      role_assignments = settings.role_assignments
    }
  }

  # Filters out any empty role assignment lists.
  role_assignments = {
    for name, settings in local.resource_groups : name => settings.role_assignments if length(settings.role_assignments) > 0
  }
}
