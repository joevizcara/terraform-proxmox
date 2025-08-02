variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "pm_api_url" {
  type    = string
  default = "https://192.168.122.34:8006/api2/json"
}

variable "pm_api_token_id" {
  type    = string
  default = "tofu-user@pam!tofu-token"
}

variable "endpoint_url" {
  type    = string
  default = "192.168.122.34/24"
}

variable "gateway_url" {
  type    = string
  default = "192.168.122.1"
}


variable "pm_node" {
  type    = string
  default = "pve"
}

variable "vm_configs" {
  type = map(object({
    vm_id = number
    vm_name = string
    vm_cores = number
    vm_memory = number
    vm_state = string
    vm_ip_address = string
  }))
  default = {
    "master-1" = { vm_id = 101, vm_name = "Master 1", vm_cores = 2, vm_memory = 4096, vm_state = running, vm_ip_address = "192.168.122.101" }
    "worker-1" = { vm_id = 201, vm_name = "Worker 1", vm_cores = 2, vm_memory = 2048, vm_state = stopped, vm_ip_address = "192.168.122.201" }
    "worker-2" = { vm_id = 202, vm_name = "Worker 2", vm_cores = 2, vm_memory = 2048, vm_state = stopped, vm_ip_address = "192.168.122.202" }
  }
}
