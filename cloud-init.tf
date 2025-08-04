resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.pm_node
  url          = "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
  overwrite    = true
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "ubuntu-24.04-minimal-cloudimg-amd64.qcow2"
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {

  for_each = var.vm_configs

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cores
    type  = "host"
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
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config.id
  }

  # machine = "q35"

  memory {
    dedicated = each.value.dedicated
    floating  = 512
  }

  name      = each.value.name
  node_name = var.pm_node

  network_device {
    bridge = "vmbr0"
  }

  on_boot       = false
  started       = each.value.started
  tablet_device = false
  scsi_hardware = "virtio-scsi-single"

  vga {
    type = "none"
  }

  vm_id = each.value.vm_id
}

data "local_file" "ssh_public_key" {
  filename = "/home/gitlab-runner/.ssh/id_rsa.pub"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: master-1
    timezone: Asia/Manila
    users:
      # - default
      - name: k3s
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_file.ssh_public_key.content)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - apt update && apt full-upgrade -y
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: master-1
    EOF

    file_name = "meta-data-cloud-config.yaml"
  }
}

output "ipv4_addresses" {
  # Use a map to collect the VM names as keys and their IPv4 addresses as values
  value = { for name, vm in proxmox_virtual_environment_vm.ubuntu_vm : name => vm.initialization[0].ip_config[0].ipv4[0].address }
}
