locals {
  image_uri = {
    ubuntu = "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
  }

  resource_name_prefix = module.config.resource_name_prefix

  default_vm_cfg = {
    os_image_uri = local.image_uri.ubuntu
  }

  network = {
    cidr       = "192.168.130.0/24"
    dns_domain = "${var.env}.local"
  }

  ssh_key_name = "${module.config.resource_name_prefix}-libvirt"

  vms = {
    master = merge(local.default_vm_cfg, {
      hostname  = "${module.config.resource_name_prefix}-master-vm"
      is_master = true
      memory_mb = 2048
      vcpus     = 1
    })
    worker-0 = merge(local.default_vm_cfg, {
      hostname = "${module.config.resource_name_prefix}-worker-vm-0"
    })
    worker-1 = merge(local.default_vm_cfg, {
      hostname = "${module.config.resource_name_prefix}-worker-vm-1"
    })
  }

  k3s_version = module.config.k3s_version
}


module "config" {
  source = "../../config"

  project = "theproject"
  env     = var.env
}
