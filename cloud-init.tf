resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.vm_node

  agent {
    enabled = true
  }

  cpu {
    cores = var.vm_cores
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.vm_node
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.tar.gz"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "tofu-noble-server-cloudimg-amd64.qcow2"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.vm_node
}
