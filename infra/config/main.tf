locals {
  projects = [
    "vm-cluster",
    "vms-init"
  ]

  tf_states = {
    for p in local.projects : p => "../../.tfstates/${p}-${var.env}.tfstate"
  }

  allowed_envs = ["dev"]

  resource_name_prefix = "${var.project}-${var.env}"

  k3s_version = "v1.32.7+k3s1"
}
