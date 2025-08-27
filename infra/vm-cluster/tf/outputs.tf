locals {
  output_vms = {
    for name, vm in module.vm : name => {
      type = local.vms[name].type
      network = {
        id                = vm.id
        network_interface = vm.network_interface
      }
      ssh_cfg = {
        host     = try(vm.ip_addresses[0], "")
        username = vm.vm_username
        key_path = abspath(local_sensitive_file.ssh_private.filename)
      }
    }
  }
}


output "vms" {
  description = "A map of all created VMs with their metadata including ssh config, netwrok"
  value       = local.output_vms
}


output "master_vm" {
  description = "Filtered master VM attributes from all VMs (single object)"
  value       = [for name, cfg in local.output_vms : merge(cfg, { name = name }) if cfg.type == "master"][0]
}


output "worker_vms" {
  description = "Filtered worker VMs attributes from all VMs (list of objects)"
  value       = { for name, cfg in local.output_vms : name => cfg if cfg.type == "worker" }
}


output "app_dns_domain" {
  description = "Base domain of the running web application"
  value       = local.network.app_dns_domain
}
