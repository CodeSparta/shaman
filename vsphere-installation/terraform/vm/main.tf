resource "vsphere_virtual_machine" "vm" {

  boot_delay	     = var.name == "bootstrap" ? 0 : 130000
  name               = var.name
  resource_pool_id   = var.resource_pool_id
  datastore_id       = var.datastore_id
  folder             = var.folder
  guest_id           = var.guest_id
  enable_disk_uuid   = "true"
  num_cpus           = var.num_cpus
  memory             = var.memory
  memory_reservation = var.memory
  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable  = "false"

  network_interface {
    network_id   = var.network_id
    adapter_type = var.network_adapter_type
  }

  disk {
    label            = "disk0"
    size             = var.disk_size
    thin_provisioned = var.disk_thin_provisioned
  }

  clone {
    template_uuid = var.template_uuid
  }

  extra_config = {
      "guestinfo.ignition.config.data"           = var.ignition_data
      "guestinfo.ignition.config.data.encoding"  = "base64"
      "guestinfo.afterburn.initrd.network-kargs" = "ip=${var.ipv4_address}::${var.gateway}:${var.netmask}:${var.name}:ens192:none ${var.dns_address}"
  }
}

