module "config" {
  source = "../../config"

  project = "vms-init"
  env     = var.env
}


locals {
  k3s_version = module.config.k3s_version
  init_runner = var.github_runner_registration_token != ""
}
