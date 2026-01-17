# requires 'Account: Account Settings Read'
data "cloudflare_account" "super-admin" {
  account_id = var.account-id
}
