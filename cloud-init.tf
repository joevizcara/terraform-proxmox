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

    for_each = var.config_files

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[each.value.hostname].id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config[each.value.hostname].id
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

  for_each = var.config_files

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${each.value.hostname}
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
      - snap remove core22
      - snap remove snapd
      - apt purge snapd -y
      - apt update && apt full-upgrade -y
      - echo "finished" > /tmp/cloud-config.finished
    EOF

    file_name = "user-data-cloud-config${each.value.hostname}.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config" {

  for_each = var.config_files

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${each.value.hostname}
    EOF

    file_name = "meta-data-cloud-config-${each.value.hostname}.yaml"
  }
}

output "ipv4_addresses" {
  # Use a map to collect the VM names as keys and their IPv4 addresses as values
  value = { for name, vm in proxmox_virtual_environment_vm.ubuntu_vm : name => vm.initialization[0].ip_config[0].ipv4[0].address }
}
