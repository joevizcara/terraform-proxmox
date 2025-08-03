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
    vm_id     = number
    name      = string
    cores     = number
    dedicated = number
    started   = bool
    address   = string
  }))
  default = {
    "master-1" = { vm_id = 101, name = "Master-1", cores = 2, dedicated = 4096, started = false, address = "192.168.1.101/24" }
    # "worker-1" = { vm_id = 201, name = "Worker-1", cores = 1, dedicated = 2048, started = false, address = "192.168.1.201/24" }
    # "worker-2" = { vm_id = 202, name = "Worker-2", cores = 1, dedicated = 2048, started = false, address = "192.168.1.202/24" }
  }
}
