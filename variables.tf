variable "account-id" {
  description = "The account ID to manage CloudFlare"
  type        = string
}

variable "google-client-id" {
  description = "The client ID to set up Google OIDC"
  type        = string
}

variable "google-client-secret" {
  description = "The client secret to set up Google OIDC"
  type        = string
}
