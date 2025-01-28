#########################
# Environment Variables
#########################

variable "name" {
  type        = string
  description = "Optional variable to set a custom name for this service in the service registry"
  default     = "Cloud Storage Service"
}

variable "prefix" {
  type        = string
  description = "Prefix for all managed resources in this module"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to created resources"
  default     = {}
}

###########################
# Azure accounts and plans
###########################

variable "use_flex_consumption_plan" {
  type        = bool
  description = "Allow enabling / disabling the usage of flex consumption plan"
  default     = true
}


variable "function_elastic_instance_minimum" {
  type        = number
  description = "Set the minimum instance number for azure functions when using premium plan"
  default     = null
}

variable "resource_group" {
  type = object({
    id       = string
    name     = string
    location = string
  })
}

variable "storage_account" {
  type = object({
    id                        = string
    name                      = string
    primary_access_key        = string
    primary_connection_string = string
    primary_blob_endpoint     = string
  })
}

variable "service_plan" {
  type = object({
    id   = string
    name = string
  })
  default = null
}

variable "app_insights" {
  type = object({
    name                = string
    connection_string   = string
    instrumentation_key = string
  })
}

variable "worker_function_timeout" {
  type        = string
  description = "Set the timeout for the worker function. Valid values depend on chosen app service plan"
  default     = null
}
