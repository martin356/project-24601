locals {
  output_vms = {
    for name, vm in module.vm : name => {
      is_master = try(local.vms[name].is_master, false)
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
  value = local.output_vms
}


output "master_vm" {
  value = [for name, cfg in local.output_vms : merge(cfg, { name = name }) if cfg.is_master][0]
}


output "worker_vms" {
  value = { for name, cfg in local.output_vms : name => cfg if !cfg.is_master }
}
