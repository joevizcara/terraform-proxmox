resource "proxmox_role" "tofu_role" {
  role_id = "tofu-role"
  privileges = [
    "Datastore.AllocateSpace",
    "Datastore.Audit",
    "Pool.Allocate",
    "Sys.Audit",
    "Sys.Console",
    "Sys.Modify",
    "VM.Allocate",
    "VM.Audit",
    "VM.Clone",
    "VM.Config.CDROM",
    "VM.Config.Cloudinit",
    "VM.Config.CPU",
    "VM.Config.Disk",
    "VM.Config.HWType",
    "VM.Config.Memory",
    "VM.Config.Network",
    "VM.Config.Options",
    "VM.Migrate",
    "VM.Monitor",
    "VM.PowerMgmt"
  ]
}
