locals {
  vm_names             = [for key, _ in local.vms : "${local.resource_name_prefix}-${key}"]
  scripts_template_dir = "${path.module}/templates"
  scripts_output_dir   = "${path.module}/.."
  local_scripts = [
    {
      filename = "clean_vms.sh"
      vars = {
        machines     = join(",", local.vm_names)
        network_name = libvirt_network.cluster.name
      }
    },
    {
      filename = "stop_vms.sh"
      vars = {
        machines = join(",", local.vm_names)
      }
    },
    {
      filename = "start_vms.sh"
      vars = {
        machines = join(",", local.vm_names)
      }
    },
    {
      filename = "update_dns_resolver.sh"
      vars = {
        bridge     = libvirt_network.cluster.bridge
        domain     = "~${local.network.dns_domain}"
        gateway_ip = cidrhost(local.network.cidr, 1)
      }
    }
  ]
}


resource "local_file" "script" {
  for_each = { for s in local.local_scripts : s.filename => s }

  filename = "${local.scripts_output_dir}/${each.value.filename}"
  content  = templatefile("${local.scripts_template_dir}/${each.value.filename}.tftpl", each.value.vars)
}
