# Vars

variable "vsphere_user"  {
  type = string
}

variable "vsphere_password"  {
  type = string
}

variable "vsphere_server"  {
  type = string
}

variable "bootstrap_complete" {
  type    = bool
  default = false
}

variable "create_infras" {
  type    = bool
  default = false
}

variable "create_workers" {
  type    = bool
  default = false
}

variable "bootstrap" {
  type = string
}

variable "masters" {
  type = map
}

variable "infras" {
  type = map
}

variable "workers" {
  type = map
}

variable "folder" {
  type = string
}

variable "datastore_id" {
  type = string
}

variable "disk_size" {
  type    = map
  default = {
    master = "120"
    worker  = "120"
    infra   = "120"
  }
}

variable "memory" {
  type    = map
  default = {
    master = "16384"
    worker = "16384"
    infra = "16384"
  }
}

variable "num_cpus" {
  type    = map
  default =  {
    master = "4"
    worker = "4"
    infra = "4"
  }
}

variable "append_bootstrap_ign_path" {
  type = string
}

variable "master_ignition_path" {
  type = string
}

variable "worker_ignition_path" {
  type = string
}

variable "resource_pool_id" {
  type = string
}

variable "guest_id" {
  type = string
  default = "coreos64Guest"
}

variable "rhcos_template" {
  type    = string
  default = "manual-rhcos-4.6.1"
}
variable "ovf_url" {
  type = string
}

variable "disk_thin_provisioned" {
  type = bool
  default = "true"
}

variable "datacenter_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "network_adapter_type" {
  type = string
  default = "vmxnet3"
}

variable "dns_address" {
  type = string
}

variable "gateway" {
  type = string
  default = "10.1.1.1"
}

variable "netmask" {
  type = string
  default = "255.255.255.0"
}
