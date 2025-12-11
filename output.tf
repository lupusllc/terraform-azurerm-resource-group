output "resource_groups" {
  description = "The resource groups."
  value       = azurerm_resource_group.this
}

output "resource_group_role_assignments" {
  description = "The resource group role assignments."
  value = merge(
    [
      for name, results in module.lupus_az_role_assignment : results.role_assignments
    ]... # Unpack the list of lists into a single list.
  )
}

### Debug:

output "var_resource_groups" {
  value = var.resource_groups
}

output "local_resource_groups" {
  value = local.resource_groups
}

output "local_resource_group_role_assignments" {
  value = local.role_assignments
}
