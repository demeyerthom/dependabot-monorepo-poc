variable "environment" {
  type        = string
  description = "Specify what environment it's in (e.g. `test` or `production`)"
}

variable "site" {
  type        = string
  description = "Identifier of the site."
}

variable "sentry_dsn" {
  type        = string
  description = "Sentry DSN"
}

variable "component_version" {
  type        = string
  description = "Version of the component"
  default     = "account"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be used on resources."
  default     = {}
}

variable "variables" {
  type = object({
    hostname                  = string
    enable_ip_whitelist       = optional(bool)
    graphql_endpoint_internal = string
    graphql_endpoint_public   = string
    gtm_id                    = optional(string)
    csp_report_only           = optional(bool, true)
    csp_report_to_percentage  = optional(number, 0)
    csp_report_to_urls        = optional(list(string), [])
  })
}

variable "secrets" {
  type        = map(string)
  description = "Map of secret values. Will be put in the key vault."
}
