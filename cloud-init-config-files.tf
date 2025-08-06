resource "proxmox_virtual_environment_file" "_master_1" {

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
      - snap remove core22
      - snap remove snapd
      - apt purge snapd -y && apt update && apt full-upgrade -y
      - echo "finished" > /tmp/cloud-config.finished
    EOF

    file_name = "user-data-cloud-config-master-1.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config_master_1" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: master-1
    EOF

    file_name = "meta-data-cloud-config-master-1.yaml"
  }
}

resource "proxmox_virtual_environment_file" "_worker_1" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: worker-1
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
      - apt purge snapd -y && apt update && apt full-upgrade -y
      - echo "finished" > /tmp/cloud-config.finished
    EOF

    file_name = "user-data-cloud-config-worker-1.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config_worker_1" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: worker-1
    EOF

    file_name = "meta-data-cloud-config-worker-1.yaml"
  }
}

resource "proxmox_virtual_environment_file" "_worker_2" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: worker-2
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
      - apt purge snapd -y && apt update && apt full-upgrade -y
      - echo "finished" > /tmp/cloud-config.finished
    EOF

    file_name = "user-data-cloud-config-worker-2.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config_worker_2" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_node

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: worker-2
    EOF

    file_name = "meta-data-cloud-config-worker-2.yaml"
  }
}
