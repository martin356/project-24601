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

    hosts {
      hostname = local.network.app_dns_domain
      ip       = local.vms.master.ip_addr
    }
  }
}


# resource "local_file" "script_exec" {
#   for_each = local.scripts_exec

#   content  = templatefile("${path.module}/templates/${each.value.filename}.tftpl", each.value.vars)
#   filename = "${path.module}/.tmp/${each.value.filename}"
# }


# resource "null_resource" "dhcp_leases" {
#   depends_on = [libvirt_network.cluster]
#   for_each   = { for s in local.scripts_exec : s.filename => s }

#   triggers = {
#     src  = sha1(file("${path.module}/scripts/${each.value.filename}"))
#     vars = jsonencode(each.value)
#   }

#   provisioner "local-exec" {
#     interpreter = ["bash", "-c"]
#     command     = file("${path.module}/scripts/${each.value.filename}")
#     environment = each.value.env_vars
#   }
# }




module "vm" {
  source   = "./modules/vm"
  for_each = local.vms

  name              = "${local.resource_name_prefix}-${each.key}"
  ssh_key           = tls_private_key.ssh.public_key_openssh
  cluster_pool_name = libvirt_pool.cluster.name
  os_image_uri      = each.value.os_image_uri
  network = {
    net_id   = libvirt_network.cluster.id
    net_name = libvirt_network.cluster.name
    ip_addr  = each.value.ip_addr
    mac_addr = each.value.mac_addr
  }
  vcpus       = each.value.vcpus
  memory_mb   = each.value.mememory_mb
  filesystems = each.value.filesystems
  vm_username = each.value.vm_username
}
