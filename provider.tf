terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~>0.80.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.30:8006/api2/json"
  pm_api_token_id = "tofu-user@pam!tofu-token"
  pm_api_token_secret = var.pm_api_token_secret
  pm_log_enable       = true                                    # Enable logging for debugging
  pm_debug            = true                                    # Enable debug mode for detailed logs
}

# variable "pm_api_token_secret" {
#   description = "proxmox api token secret"
#   type = string
#   sensitive = true
# }
