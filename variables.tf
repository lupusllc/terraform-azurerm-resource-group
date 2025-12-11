### Defaults

variable "defaults" {
  default     = {} # Defaults to an empty map.
  description = "Defaults used for resources when nothing is specified for the resource."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type        = any
}

### Required

variable "required" {
  default     = {} # Defaults to an empty map.
  description = "Required resource values, as applicable."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type        = any
}

### Dependencies

### Resources

variable "resource_groups" {
  default     = [] # Defaults to an empty list.
  description = "Resource Groups."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type = list(object({
    ### Basic

    location = optional(string)
    name     = string
    tags     = optional(map(string), {})

    ###### Role Assignments

    # This allows role assignments to be assigned as part of this module, since scope is already known.
    role_assignments = optional(any, [])
  }))
}
