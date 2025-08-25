module "config" {
  source = "../../config"

  project = "vms-init"
  env     = var.env
}


locals {
  k3s_version = module.config.k3s_version
}
