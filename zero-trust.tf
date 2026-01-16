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

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.account-id
  name       = "raspberry pi"
  config_src = "cloudflare"
}
