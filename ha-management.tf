resource "proxmox_virtual_environment_haresource" "ha-master-1" {
  resource_id = "vm:101"
  state       = "started"
  comment     = "Managed by OpenTofu"
}

resource "proxmox_virtual_environment_haresource" "ha-worker-1" {
  depends_on = [
    proxmox_virtual_environment_vm.ubuntu_vm["master-1"]
  ]
  resource_id = "vm:201"
  state       = "started"
  comment     = "Managed by OpenTofu"
}

resource "proxmox_virtual_environment_haresource" "ha-worker-2" {
  depends_on = [
    proxmox_virtual_environment_vm.ubuntu_vm["worker-1"]
  ]
  resource_id = "vm:202"
  state       = "started"
  comment     = "Managed by OpenTofu"
}
