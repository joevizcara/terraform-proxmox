variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "pm_api_url" {
  type    = string
  default = "https://192.168.1.30:8006/api2/json"
}

variable "pm_api_token_id" {
  type    = string
  default = "tofu-user@pam!tofu-token"
}

variable "endpoint_url" {
  type    = string
  default = "192.168.1.30/24"
}

variable "gateway_url" {
  type    = string
  default = "192.168.1.1"
}


variable "pm_node" {
  type    = string
  default = "neo"
}

variable "vm_configs" {
  type = map(object({
    vm_id                  = number
    name                   = string
    cores                  = number
    dedicated              = number
    started                = bool
    address                = string
    user_data_cloud_config = string
    meta_data_cloud_config = string
  }))
  default = {

    "master-1" = {
      vm_id                  = 101,
      name                   = "K3S-Master-1",
      cores                  = 2, dedicated = 4096,
      started                = false,
      address                = "192.168.1.101/24",
      user_data_cloud_config = "local:snippets/user-data-cloud-config-master-1.yaml",
      meta_data_cloud_config = "local:snippets/meta-data-cloud-config-master-1.yaml"
    }

    # "master-2" = {
    # vm_id = 102,
    # name = "K3S-Master-2",
    # cores = 2,
    # dedicated = 4096,
    # started = false,
    # address = "192.168.1.102/24"
    # user_data_cloud_config = "proxmox_virtual_environment_file.user_data_cloud_config_master_2.id",
    # meta_data_cloud_config = "proxmox_virtual_environment_file.meta_data_cloud_config_master_2.id"
    # }

    "worker-1" = {
      vm_id = 201,
      name = "K3S-Worker-1",
      cores = 1,
      dedicated = 2048,
      started = false,
      address = "192.168.1.201/24",
      user_data_cloud_config = "local:snippets/user-data-cloud-config-worker-1.yaml",
      meta_data_cloud_config = "local:snippets/meta-data-cloud-config-worker-1.yaml"
    }

    "worker-2" = {
      vm_id = 202,
      name = "K3S-Worker-2",
      cores = 1,
      dedicated = 2048,
      started = false,
      address = "192.168.1.202/24",
      user_data_cloud_config = "local:snippets/user-data-cloud-config-worker-2.yaml",
      meta_data_cloud_config = "local:snippets/meta-data-cloud-config-worker-2.yaml"
    }

    # "worker-3" = {
    # vm_id = 203,
    # name = "K3S-Worker-3",
    # cores = 1, dedicated = 2048,
    # started = false, address = "192.168.1.203/24"
    # user_data_cloud_config = "proxmox_virtual_environment_file.user_data_cloud_config_worker_3.id",
    # meta_data_cloud_config = "proxmox_virtual_environment_file.meta_data_cloud_config_worker_3.id"
    # }

  }
}
