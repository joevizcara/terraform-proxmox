resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.pm_node
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "noble-server-cloudimg-amd64.qcow2"
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {

  for_each = var.vm_configs

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cores
    numa  = true
    type  = "x86-64-v2-AES"
  }

  disk {
    cache        = "writeback"
    datastore_id = "local-lvm"
    discard      = "on"
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    size         = 16
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.address
        gateway = var.gateway_url
      }
    }
    user_data_file_id = each.value.user_data_cloud_config
    meta_data_file_id = each.value.meta_data_cloud_config
  }

  machine = "q35"

  memory {
    dedicated = each.value.dedicated
    floating  = 512
  }

  name      = each.value.name
  node_name = var.pm_node

  network_device {
    bridge = "vmbr0"
  }

  on_boot         = false
  started         = each.value.started
  stop_on_destroy = true
  tablet_device   = false
  scsi_hardware   = "virtio-scsi-single"

  vga {
    memory = 0
    type   = "none"
  }

  vm_id = each.value.vm_id
}

data "local_file" "ssh_public_key" {
  filename = "/home/gitlab-runner/.ssh/id_rsa.pub"
}

output "ipv4_addresses" {
  value = { for name, vm in proxmox_virtual_environment_vm.ubuntu_vm : name => vm.initialization[0].ip_config[0].ipv4[0].address }
}
