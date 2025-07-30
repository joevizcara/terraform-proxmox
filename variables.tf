# variable "pm_api_token_secret" {
#   type      = string
#   sensitive = true
# }

variable "pm_api_url" {
  type    = string
  default = "https://192.168.1.30:8006/api2/json"
}

variable "pm_api_token_id" {
  type    = string
  default = "tofu-user@pam!tofu-token"
}

variable "endpoint_url" {
  type = string
  default = "192.168.1.30/24"
}

variable "gateway_url" {
  type = string
  default = "192.168.1.1"
}

variable "vm_name" {
  type = string
  default = "ubuntu-cloud-init"
}

variable "vm_node" {
  type = string
  default = "neo"
}

variable "vm_cores" {
  type = number
  default = 2
}

variable "vm_memory" {
  type = number
  default = 2048
}
