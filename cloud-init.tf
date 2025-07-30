# resource "proxmox_virtual_environment_vm" "ubuntu_clone" {
#   name      = "ubuntu-clone"
#   node_name = var.vm_node

#   clone {
#     vm_id = proxmox_virtual_environment_vm.ubuntu_template.id
#   }

#   agent {
#     # NOTE: The agent is installed and enabled as part of the cloud-init configuration in the template VM, see cloud-config.tf
#     # The working agent is *required* to retrieve the VM IP addresses.
#     # If you are using a different cloud-init configuration, or a different clone source
#     # that does not have the qemu-guest-agent installed, you may need to disable the `agent` below and remove the `vm_ipv4_address` output.
#     # See https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#qemu-guest-agent for more details.
#     enabled = true
#   }

#   memory {
#     dedicated = 768
#   }

#   initialization {
#     dns {
#       servers = ["1.1.1.1"]
#     }
#     ip_config {
#       ipv4 {
#         address = "dhcp"
#       }
#     }
#   }
# }

# output "vm_ipv4_address" {
#   value = proxmox_virtual_environment_vm.ubuntu_clone.ipv4_addresses[1][0]
# }







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
  content_type = "image"
  datastore_id = "local"
  node_name    = var.vm_node
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "jammy-server-cloudimg-amd64.qcow2"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.vm_node
}
