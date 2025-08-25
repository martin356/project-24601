output "id" {
  value = libvirt_domain.vm.id
}


output "network_interface" {
  value = libvirt_domain.vm.network_interface
}


output "ip_addresses" {
  value = libvirt_domain.vm.network_interface[0].addresses
}


output "vm_username" {
  value = local.vm_username
}
