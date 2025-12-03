This [public repo](https://github.com/lupusllc/terraform-azurerm-resource-group) is the source for this public Terraform module.
  
## Purpose
  
This module was created to expand provider capabilities, implement org standards and defaults. 
  
This helps shift complexity right (module side), while reducing complexity left (root/user side). So configuration is more easily defined at the vars/tfvars level.
  
### Enhanced Capabilities
  
* Uses a list of objects to create zero or more resources.
* Uses a default map for common defaults, when not provided.
  * Location
  * Resource Group
  * Tags
* Uses a required map for required items, that should be on all applicable resources.
  * Tags
* Handles dependencies checking at the module level.
* Root/user level terraform is more simplified.
  
## Provider
  
This module uses the azurerm provider.
  
## Arguments: Root Level
  
Arguments | Required | Type | Default | Example | Description
--------- | -------- | ---- | ------- | ------- | -----------
defaults | no | map() | {} | [See Example](#arguments-defaults-example) | Default items to use for resources for this and sub-modules if those aren't provided.
resource_groups | no | list(object()) | [] | [See Example](#arguments-resource_groups-example) | A list of objects, used to create zero or more resource groups.
required | no | map() | {} | [See Example](#arguments-required-example) | Required items to use for resources for this and sub-modules, as applicable.
  
## Arguments: defaults
  
The defaults map uses the following for resources created, if those settings aren't provided.
  
Arguments | Required | Type | Default | Example | Description
--------- | -------- | ---- | ------- | ------- | -----------
location | no | string | | [See Example](#arguments-defaults-example) | Resource location.
tags | no | map(string) | | [See Example](#arguments-defaults-example) | Resource tags.
  
### Arguments: defaults: Example
  
```
{
  location = "eastus"
  tags = { default_tag = "default level" }
}
```
  
## Arguments: resource_groups
  
The resource_groups list of objects defines the resource groups to be created.
  
Arguments | Required | Type | Default | Example | Description
--------- | -------- | ---- | ------- | ------- | -----------
location | yes* | string | | [See Example](#arguments-resource_groups-example) | Resource location.
name | yes | string | | [See Example](#arguments-resource_groups-example) | Resource name.
tags | no | map(string) | | [See Example](#arguments-resource_groups-example) | Resource tags, these tags will be combined with required tags if provided.
  
\* These are only required if defaults do not provide these values.
  
### Arguments: resource_groups: Example
  
```
[
  {
    name = "example-min-wus-rg"
    location = "westus"
    tags = { resource_tag = "resource level" }
  }
]
```
  
## Arguments: required
  
The required map uses the following for all applicable resources created.
  
Arguments | Required | Type | Default | Example | Description
--------- | -------- | ---- | ------- | ------- | -----------
tags | no | map(string) | | [See Example](#arguments-required-example) | Resource tags.
  
### Arguments: required: Example
  
```
{
  tags = { required_tag = "required level" }
}
```
  
## Examples: Minimal
  
The example below is a minimal example of to use this module.
  
Usually you would use variables.tf, main.tf, tfvars, and other files, but this is just basic example.
  
```
### Variables

variable "resource_groups" {
  default     = [{
      name = "example-min-wus-rg"
      location = "westus"
  }]
}
  
### Resources/Modules
  
module "resource-group" {
  source  = "lupusllc/resource-group/azurerm"
  version = "0.0.1"

  resource_groups = var.resource_groups
}
```
  
## Examples: Fuller
  
The example below is a fuller example of the use this module.
  
Usually you would use variables.tf, main.tf, tfvars, and other files, but this is just basic example.
  
```
### Variables

variable "defaults" {
  default     = {
    location = "eastus"
    tags = { default_tag = "default level" }
  }
}

variable "resource_groups" {
  default     = [
    {
      name = "example-min-wus-rg"
      location = "westus"
    },
    {
      name = "example-min-eus-rg"
      tags = { resource_tag = "resource level" }
    }
  ]
}

variable "required" {
  default     = {
    tags = { required_tag = "required level" }
  }
}

### Resources/Modules

module "resource-group" {
  source  = "lupusllc/resource-group/azurerm"
  version = "0.0.1"

  defaults        = var.defaults
  resource_groups = var.resource_groups
  required        = var.required
}
```
  
