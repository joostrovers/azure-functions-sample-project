variable "AZURE_TENANT_ID" {
  type        = string
  description = "Azure Tenant Id where infrastructure will be deployed. Set through TF_VAR_ environment variable"
  default     = null
}

variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription Id where infrastructure will be deployed. Set through TF_VAR_ environment variable"
  default     = null
}

variable "AZURE_CLIENT_ID" {
  type        = string
  description = "Azure Client ID where infrastructure will be deployed. Set through TF_VAR_ environment variable"
  default     = null
}

variable "AZURE_CLIENT_SECRET" {
  type        = string
  description = "Azure Client Secret where infrastructure will be deployed. Set through TF_VAR_ environment variable"
  default     = null
}

variable "prefix" {
  type        = string
  description = "Prefix for all managed resources"
  default     = "afsp-test"
}

variable azure_location {
  type        = string
  description = "Azure Location where infrastructure will be deployed"
  default     = "westeurope"
}

variable application_insights_smart_detection_email_recipients {
  type = list(string)
  description = "Email addresses that should receive application insights emails"
  default     = []
}
