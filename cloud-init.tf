
resource "null_resource" "check_file" {
  provisioner "local-exec" {
    command = <<EOT
      # Replace with your Proxmox API or SSH command to check file existence
      ssh root@${var.pm_node} "test -f /var/lib/vz/import/noble-server-cloudimg-amd64.qcow2 && echo 'exists' || echo 'non-existent'" > file_check.txt
    EOT
  }
}

# Read the result of the file check
data "local_file" "file_check" {
  filename   = "file_check.txt"
  depends_on = [null_resource.check_file]
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  count        = data.local_file.file_check.content == "non-existent" ? 1 : 0
  content_type = "import"
  datastore_id = "local"
  node_name    = var.pm_node
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite    = false
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "noble-server-cloudimg-amd64.qcow2"
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
    hostname: ubuntu-user
    timezone: Asia/Manila
    users:
      - default
      - name: ubuntu
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
    local-hostname: ubuntu-meta
    EOF

    file_name = "meta-data-cloud-config.yaml"
  }
}


resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "ubuntu-ci"
  node_name = var.pm_node

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image[0].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 16
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config.id

  }

  network_device {
    bridge = "vmbr0"
  }

}

output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses[1][0]
}
