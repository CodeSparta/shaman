provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter_id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_id
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool_id
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_id
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name                  = "${var.folder}/${var.rhcos_template}"
  datacenter_id         = data.vsphere_datacenter.dc.id
}

# Add resources for vm template and folder

module "bootstrap" {
  count                 = var.bootstrap_complete ? 0 : 1
  source                = "./vm"
  name                  = "bootstrap"
  folder                = var.folder
  datastore_id          = data.vsphere_datastore.datastore.id
  disk_size             = var.disk_size["master"]
  memory                = var.memory["master"]
  num_cpus              = var.num_cpus["master"]
  ignition_data         = filebase64(var.append_bootstrap_ign_path)

  resource_pool_id 	= data.vsphere_resource_pool.pool.id
  guest_id              = var.guest_id 
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = var.disk_thin_provisioned
  
  network_id            = data.vsphere_network.network.id
  network_adapter_type  = var.network_adapter_type

  dns_address    	= var.dns_address
  gateway        	= var.gateway
  ipv4_address   	= var.bootstrap
  netmask        	= var.netmask
}

module "master" {
  for_each		= var.masters
#  depends_on 		= ["vsphere_virtual_machine.bootstrap"]
  source                = "./vm"
  name                  = each.key
  folder                = var.folder
  datastore_id          = data.vsphere_datastore.datastore.id
  disk_size             = var.disk_size["master"]
  memory                = var.memory["master"]
  num_cpus              = var.num_cpus["master"]
  ignition_data         = filebase64(var.master_ignition_path)

  resource_pool_id 	= data.vsphere_resource_pool.pool.id
  guest_id              = var.guest_id 
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = var.disk_thin_provisioned
  
  network_id            = data.vsphere_network.network.id
  network_adapter_type  = var.network_adapter_type

  dns_address    	= var.dns_address
  gateway        	= var.gateway
  ipv4_address   	= each.value
  netmask        	= var.netmask
}

module "infra" {
  for_each		= var.infras
#  depends_on            = ["vsphere_virtual_machine.bootstrap"]
  source                = "./vm"
  name                  = each.key
  folder                = var.folder
  datastore_id          = data.vsphere_datastore.datastore.id
  disk_size             = var.disk_size["infra"]
  memory                = var.memory["infra"]
  num_cpus              = var.num_cpus["infra"]
  ignition_data         = filebase64(var.worker_ignition_path)

  resource_pool_id 	= data.vsphere_resource_pool.pool.id
  guest_id              = var.guest_id 
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = var.disk_thin_provisioned
  
  network_id            = data.vsphere_network.network.id
  network_adapter_type  = var.network_adapter_type

  dns_address    	= var.dns_address
  gateway        	= var.gateway
  ipv4_address   	= each.value
  netmask        	= var.netmask
}

module "worker" {
  for_each		= var.workers
#  depends_on            = ["vsphere_virtual_machine.bootstrap"]
  source                = "./vm"
  name                  = each.key
  folder                = var.folder
  datastore_id          = data.vsphere_datastore.datastore.id
  disk_size             = var.disk_size["worker"]
  memory                = var.memory["worker"]
  num_cpus              = var.num_cpus["worker"]
  ignition_data         = filebase64(var.worker_ignition_path)

  resource_pool_id 	= data.vsphere_resource_pool.pool.id
  guest_id              = var.guest_id 
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = var.disk_thin_provisioned
  
  network_id            = data.vsphere_network.network.id
  network_adapter_type  = var.network_adapter_type

  dns_address    	= var.dns_address
  gateway        	= var.gateway
  ipv4_address   	= each.value
  netmask        	= var.netmask
}
