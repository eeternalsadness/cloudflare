resource "cloudflare_zero_trust_organization" "organization" {
  zone_id                     = cloudflare_zone.zone.id
  allow_authenticate_via_warp = false
  auth_domain                 = "eeternalsadness.cloudflareaccess.com"
  is_ui_read_only             = false
  name                        = "eeternalsadness.cloudflareaccess.com"
}
