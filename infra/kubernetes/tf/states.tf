locals {
  remote_states = ["vm-cluster", "vms-init"]

  vm_cluster = data.terraform_remote_state.project["vm-cluster"].outputs
  vms_init   = data.terraform_remote_state.project["vms-init"].outputs
}


data "terraform_remote_state" "project" {
  for_each = toset(local.remote_states)

  backend = "local"
  config = {
    path = module.config.tf_states[each.key]
  }
}
