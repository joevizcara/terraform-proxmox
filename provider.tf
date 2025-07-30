terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.80.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_api_token_id}=7857da3e-5a65-4798-a529-8949e0046232"
  insecure  = true
}
