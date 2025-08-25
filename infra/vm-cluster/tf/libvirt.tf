resource "libvirt_pool" "cluster" {
  name = "${module.config.resource_name_prefix}-cluster"
  type = "dir"

  target {
    path = "/var/lib/libvirt/images/${module.config.resource_name_prefix}"
  }
}


resource "libvirt_network" "cluster" {
  name      = "${module.config.resource_name_prefix}-net"
  mode      = "nat"
  autostart = true
  addresses = [local.network.cidr]
  domain    = local.network.dns_domain

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }
}


module "vm" {
  source   = "./modules/vm"
  for_each = local.vms

  name              = "${local.resource_name_prefix}-${each.key}"
  ssh_key           = tls_private_key.ssh.public_key_openssh
  cluster_pool_name = libvirt_pool.cluster.name
  os_image_uri      = each.value.os_image_uri
  network_id        = libvirt_network.cluster.id
  vcpus             = try(each.value.vcpus, 1)
  memory_mb         = try(each.value.mememory_mb, 1024)
}
