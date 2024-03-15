terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.50.0"
    }
  }
}

data "google_client_config" "default" {}

locals {
  component_name = "hbm-machines"
  image          = "europe-west4-docker.pkg.dev/hbm-ecom-svc/mach-registry/site-${local.component_name}:${var.component_version}"
}

module "cloud_run" {
  source = "git::https://github.com/hbm-machines/terraform-modules.git//cloud-run"
  name   = local.component_name
  image  = local.image

  invoke_allow_all        = true
  ingress                 = "INGRESS_TRAFFIC_ALL"
  vpc_egress_private_only = true

  env = {
    NODE_ENV       = "production"
    ENVIRONMENT    = var.environment
    SITE           = var.site
    COMPONENT_NAME = local.component_name

    HOST_NAME = var.variables.hostname

    SENTRY_DSN         = var.sentry_dsn
    SENTRY_ENVIRONMENT = var.environment
    SENTRY_RELEASE     = "${local.component_name}@${var.component_version}"

    NEXT_PUBLIC_ENVIRONMENT = var.environment
    NEXT_PUBLIC_GTM_ID      = var.variables.gtm_id

    CSP_REPORT_ONLY       = var.variables.csp_report_only
    CSP_REPORT_PERCENTAGE = var.variables.csp_report_to_percentage
    CSP_REPORT_URLS       = join(",", var.variables.csp_report_to_urls)

    SERVER_API_GATEWAY_URL = var.variables.graphql_endpoint_internal
    CLIENT_API_GATEWAY_URL = var.variables.graphql_endpoint_public
    KEEP_ALIVE_TIMEOUT     = tostring(120 * 1000)
  }

  ports = {
    "name" : "http1",
    "port" : 4000
  }
}

