resource "null_resource" "proxmox_role" {
  triggers = {
    run_once = "initial_setup"
  }

  provisioner "local-exec" {
    command = <<EOT
      # pveum role add tofu-role -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt" || \
      pveum role modify tofu-role -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
      # pveum aclmod / -user tofu-user@pam -role tofu-role
    EOT
    environment = {
      PM_API_URL          = "https://192.168.1.30:8006/api2/json" # Replace with Proxmox node IP/hostname
      PM_API_TOKEN_ID     = "tofu-user@pam!tofu-token"
      PM_API_TOKEN_SECRET = var.pm_api_token_secret
    }
  }
}

# variable "pm_api_token_secret" {
#   description = "Proxmox API token secret"
#   type        = string
#   sensitive   = true
# }
