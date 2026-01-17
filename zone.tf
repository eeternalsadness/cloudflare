resource "cloudflare_zone" "zone" {
  account = {
    id = data.cloudflare_account.super-admin.account_id
  }
  name = "eeternalsadness.dev"
  type = "full"
}

import {
  id = data.cloudflare_account.super-admin.account_id
  to = cloudflare_zone.zone
}
