terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.81.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"
  insecure  = true
}
