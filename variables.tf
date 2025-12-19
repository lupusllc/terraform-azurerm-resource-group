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

    ###### Sub-resource & Additional Modules
    # Since parent is known, these can be created here, which makes it easier for users.
    # We don't specify the type here because the module itself will validate the structure. See the module variables for details for configuration.
    #
    # WARNING: Moving these resources to it's direct module will require recreation or state file manipulation.

    role_assignments = optional(any, [])
  }))
}
