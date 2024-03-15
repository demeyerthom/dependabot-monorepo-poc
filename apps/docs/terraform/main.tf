terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.20.0"
    }
  }
}

data "google_client_config" "default" {}

locals {
  component_name = "hbm-machines"
  image          = "europe-west4-docker.pkg.dev/hbm-ecom-svc/mach-registry/site-${local.component_name}:${var.component_version}"
}

