variable "name" {
  type = string
}

variable "ignition_data" {
  type = string
  default = ""
}

variable "guest_id" {
  type = string
}

variable "resource_pool_id" {
  type = string
}

variable "folder" {
  type = string
}

variable "template_uuid" {
  type = string
}

variable "disk_thin_provisioned" {
  type = bool
  default = "true"
}

variable "disk_size" {
  type = string
}

variable "memory" {
  type    = string
}

variable "num_cpus" {
  type    = string
}

variable "datastore_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "network_adapter_type" {
  type = string
}

variable "gateway" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "netmask" {
  type = string
}

variable "dns_address" {
  type = string
}
