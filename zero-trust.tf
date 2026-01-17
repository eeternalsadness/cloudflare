resource "cloudflare_zero_trust_organization" "organization" {
  zone_id = cloudflare_zone.zone.id

  name        = "eeternalsadness.cloudflareaccess.com"
  auth_domain = "eeternalsadness.cloudflareaccess.com"

  allow_authenticate_via_warp = false
  # auto_redirect_to_identity = false

  is_ui_read_only = false
  # ui_read_only_toggle_reason = ""

  # session_duration                   = "24h"
  # user_seat_expiration_inactive_time = "730h"
  # warp_auth_session_duration         = "24h"

  # custom_pages = {
  #   forbidden = "699d98642c564d2e855e9661899b7252"
  #   identity_denied = "699d98642c564d2e855e9661899b7252"
  # }
  # login_design = {
  #   background_color = "#c5ed1b"
  #   footer_text = "This is an example description."
  #   header_text = "This is an example description."
  #   logo_path = "https://example.com/logo.png"
  #   text_color = "#c5ed1b"
  # }
}

resource "cloudflare_zero_trust_access_identity_provider" "google" {
  config = {
    client_id = var.google-client-id
    # client_secret = var.google-client-secret
  }
  name       = "Google"
  type       = "google"
  account_id = var.account-id
}

resource "cloudflare_zero_trust_access_policy" "policy" {
  account_id = var.account-id
  name       = "Allow me"

  approval_required = false
  session_duration  = "6h"

  decision = "allow"
  include = [
    {
      email = {
        email = "69bnguyen@gmail.com"
      }
    }
  ]
  require = [
    {
      email = {
        email = "69bnguyen@gmail.com"
      }
    }
  ]
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.account-id
  name       = "raspberry pi"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "tunnel-route" {
  account_id = var.account-id
  network    = "192.168.0.0/24"
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  comment    = "Homelab network"
}

resource "cloudflare_zero_trust_device_default_profile" "device-default-profile" {
  account_id = var.account-id

  allow_mode_switch = false
  allow_updates     = false
  allowed_to_leave  = true

  auto_connect          = 0
  captive_portal        = 180
  disable_auto_fallback = false
  exclude_office_ips    = false

  include = [
    {
      address     = cloudflare_zero_trust_tunnel_cloudflared_route.tunnel-route.network
      description = cloudflare_zero_trust_tunnel_cloudflared_route.tunnel-route.comment
    },
    {
      description = "zero trust domain"
      host        = cloudflare_zero_trust_organization.organization.auth_domain
    }
  ]
  # lan_allow_minutes              = 30
  # lan_allow_subnet_size          = 24
  register_interface_ip_with_dns = true
  sccm_vpn_boundary_support      = false
  service_mode_v2 = {
    mode = "warp"
  }
  switch_locked   = false
  tunnel_protocol = "wireguard"
}

resource "cloudflare_zero_trust_device_default_profile_local_domain_fallback" "device-default-local-domain-fallback" {
  account_id = var.account-id
  domains = [{
    suffix     = "home.lan"
    dns_server = ["192.168.0.42"]
  }]
}
