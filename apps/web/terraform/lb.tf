
resource "google_compute_region_network_endpoint_group" "main" {
  name                  = "hbm-machines-neg"
  network_endpoint_type = "SERVERLESS"
  region                = data.google_client_config.default.region
  cloud_run {
    service = module.cloud_run.service_name
  }
}

locals {
  enable_ip_whitelist = lookup(var.variables, "enable_ip_whitelist", false)
  security_policy     = local.enable_ip_whitelist == true ? "projects/${data.google_client_config.default.project}/global/securityPolicies/ip-whitelist" : null
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 9.0"
  name    = "hbm-machines-lb"
  project = data.google_client_config.default.project

  ssl                             = true
  managed_ssl_certificate_domains = [var.variables.hostname]
  https_redirect                  = true

  backends = {
    default = {
      description     = null
      security_policy = local.security_policy
      groups = [
        {
          group = google_compute_region_network_endpoint_group.main.id
        }
      ]
      enable_cdn = true
      cdn_policy = {
        signed_url_cache_max_age_sec = 3600
        cache_mode                   = "USE_ORIGIN_HEADERS"
      }

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }
    }
  }
}
