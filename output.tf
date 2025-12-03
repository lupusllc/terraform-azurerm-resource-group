output "resource_groups" {
  description = "The resource groups."
  value       = azurerm_resource_group.this
}

### Debug:

output "var_resource_groups" {
  value = var.resource_groups
}

output "local_resource_groups" {
  value = local.resource_groups
}
