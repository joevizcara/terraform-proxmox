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
  default = "pve"
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
    resource_id            = string
  }))
  default = {

    "master-1" = {
      vm_id                  = 101,
      name                   = "K3s-Master-1",
      cores                  = 2,
      dedicated              = 4096,
      started                = false,
      address                = "192.168.1.101/24",
      user_data_cloud_config = "local:snippets/user-data-cloud-config-master-1.yaml",
      meta_data_cloud_config = "local:snippets/meta-data-cloud-config-master-1.yaml"
      resource_id            = "local:import/noble-server-cloudimg-amd64.qcow2"
    }

    # "master-2" = {
    # vm_id = 102,
    # name = "K3s-Master-2",
    # cores = 2,
    # dedicated = 4096,
    # started = false,
    # address = "192.168.1.102/24"
    # user_data_cloud_config = "local:snippets/user-data-cloud-config-master-2.yaml"",
    # meta_data_cloud_config = "local:snippets/meta-data-cloud-config-master-2.yaml""
    # }

    "worker-1" = {
      vm_id                  = 201,
      name                   = "K3s-Worker-1",
      cores                  = 1,
      dedicated              = 2048,
      started                = false,
      address                = "192.168.1.201/24",
      user_data_cloud_config = "local:snippets/user-data-cloud-config-worker-1.yaml",
      meta_data_cloud_config = "local:snippets/meta-data-cloud-config-worker-1.yaml"
      resource_id            = "101"
    }

    "worker-2" = {
      vm_id                  = 202,
      name                   = "K3s-Worker-2",
      cores                  = 1,
      dedicated              = 2048,
      started                = false,
      address                = "192.168.1.202/24",
      user_data_cloud_config = "local:snippets/user-data-cloud-config-worker-2.yaml",
      meta_data_cloud_config = "local:snippets/meta-data-cloud-config-worker-2.yaml"
      resource_id            = "201"
    }

    # "worker-3" = {
    # vm_id = 203,
    # name = "K3s-Worker-3",
    # cores = 1, dedicated = 2048,
    # started = false, address = "192.168.1.203/24"
    # user_data_cloud_config = "local:snippets/user-data-cloud-config-worker-3.yaml",
    # meta_data_cloud_config = "local:snippets/meta-data-cloud-config-worker-3.yaml"
    # }

  }
}
