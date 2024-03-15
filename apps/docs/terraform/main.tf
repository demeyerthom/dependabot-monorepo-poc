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

