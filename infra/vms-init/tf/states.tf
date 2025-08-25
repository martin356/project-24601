locals {
  vm_cluster = data.terraform_remote_state.vm_cluster.outputs
}


data "terraform_remote_state" "vm_cluster" {
  backend = "local"

  config = {
    path = module.config.tf_states.vm-cluster
  }
}
