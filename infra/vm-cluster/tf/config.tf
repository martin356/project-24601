locals {
  image_uri = {
    ubuntu = "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
  }

  default_vm_cfg = {
    os_image_uri = local.image_uri.ubuntu
    vcpus        = 1
    mememory_mb  = 1024
    filesystems  = []
    vm_username  = "ubuntu"
  }

  network = {
    cidr           = var.network_cidr
    dns_domain     = "${var.env}.${module.config.project}"
    app_dns_domain = "app.${var.env}.${module.config.project}"
  }

  ssh_key_name = "${module.config.resource_name_prefix}-libvirt"

  vms = {
    master = merge(local.default_vm_cfg, {
      type      = "master"
      hostname  = "${module.config.resource_name_prefix}-master-vm"
      memory_mb = 4096
      vcpus     = 2
      ip_addr   = "192.168.130.9"
      mac_addr  = "52:54:00:76:C4:11"
    })
    worker-0 = merge(local.default_vm_cfg, {
      type      = "worker"
      hostname  = "${module.config.resource_name_prefix}-worker-vm-0"
      memory_mb = 2048
      ip_addr   = "192.168.130.100"
      mac_addr  = "52:54:00:42:6A:66"
    })
    worker-1 = merge(local.default_vm_cfg, {
      type      = "worker"
      hostname  = "${module.config.resource_name_prefix}-worker-vm-1"
      memory_mb = 2048
      ip_addr   = "192.168.130.101"
      mac_addr  = "52:54:00:8E:81:59"
    })
    github-runner = merge(local.default_vm_cfg, {
      type      = "runner"
      hostname  = "${module.config.resource_name_prefix}-github-runner"
      memory_mb = 2048
      ip_addr   = "192.168.130.20"
      mac_addr  = "52:54:00:8E:81:55"
      # filesystems = [{
      #   source = module.config.tf_states_dir
      #   target   = "/home/${local.default_vm_cfg.vm_username}/.tfstates"
      #   readonly = false
      # }]
    })
  }

  scripts_exec = [
    {
      filename = "dhcp_leases.sh"
      env_vars = {
        LEASEFILE      = "/var/lib/libvirt/dnsmasq/${libvirt_network.cluster.name}.leases"
        HOSTNAMES_JSON = jsonencode([for vm in local.vms : vm.hostname])
      }
    }
  ]

  resource_name_prefix = module.config.resource_name_prefix
  k3s_version          = module.config.k3s_version
}


module "config" {
  source = "../../config"

  project = "theproject"
  env     = var.env
}
