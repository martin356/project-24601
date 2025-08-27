locals {
  k3s_url = "https://${local.master_vm_cfg.ssh.host}:${local.master_vm_cfg.init_script_cfg.vars.k3s_port}"

  init_scripts_dir = "${path.module}/init_scripts"

  master_vm_cfg = {
    ssh = local.vm_cluster.master_vm.ssh_cfg
    init_script_cfg = {
      template = "k3s_controlplane.sh.tftpl"
      vars = {
        k3s_version = local.k3s_version
        k3s_token   = nonsensitive(random_password.k3s_token.result)
        k3s_port    = 6443
      }
    }
  }

  worker_vms_cfg = {
    for name, vm in local.vm_cluster.worker_vms : name => {
      ssh = vm.ssh_cfg
      init_script_cfg = {
        template = "k3s_agent.sh.tftpl"
        vars = {
          k3s_version   = local.k3s_version
          k3s_token     = nonsensitive(random_password.k3s_token.result)
          k3s_url       = local.k3s_url
          k3s_node_name = name
        }
      }
    }
  }
}


resource "local_file" "init_scripts" {
  for_each = merge(local.worker_vms_cfg, {
    master = local.master_vm_cfg
  })

  content  = templatefile("${local.init_scripts_dir}/${each.value.init_script_cfg.template}", each.value.init_script_cfg.vars)
  filename = "${path.module}/.tmp/${each.key}.sh"
}


resource "random_password" "k3s_token" {
  length  = 48
  special = false
}


resource "null_resource" "k3s_server" {
  triggers = {
    script_hash = local_file.init_scripts["master"].content_sha1
    host        = local.master_vm_cfg.ssh.host
    token_hash  = sha1(random_password.k3s_token.result)
    k3s_version = local.k3s_version
  }

  connection {
    type        = "ssh"
    host        = nonsensitive(local.master_vm_cfg.ssh.host)
    user        = nonsensitive(local.master_vm_cfg.ssh.username)
    private_key = nonsensitive(file(local.master_vm_cfg.ssh.key_path))
  }

  provisioner "remote-exec" {
    scripts = [
      local_file.init_scripts["master"].filename,
      "${local.init_scripts_dir}/netplan_apply.sh"
    ]
  }
}


resource "null_resource" "k3s_agent" {
  depends_on = [null_resource.k3s_server]
  for_each   = local.worker_vms_cfg

  triggers = {
    master_host = local.master_vm_cfg.ssh.host
    host        = each.value.ssh.host
    token_hash  = sha1(random_password.k3s_token.result)
    k3s_version = local.k3s_version
  }

  connection {
    type        = "ssh"
    host        = nonsensitive(each.value.ssh.host)
    user        = nonsensitive(each.value.ssh.username)
    private_key = nonsensitive(file(each.value.ssh.key_path))
  }

  provisioner "remote-exec" {
    scripts = [
      local_file.init_scripts[each.key].filename,

    ]
  }
}


data "external" "k3s_kubeconfig" {
  depends_on = [
    null_resource.k3s_server,
    null_resource.k3s_agent
  ]

  program = ["bash", "${path.module}/init_scripts/read_remote_file.sh"]

  query = {
    host          = local.master_vm_cfg.ssh.host
    user          = local.master_vm_cfg.ssh.username
    identity_file = local.master_vm_cfg.ssh.key_path
    path          = "/etc/rancher/k3s/k3s.yaml"
  }
}


resource "null_resource" "github_runner" {
  count = local.init_runner ? 1 : 0

  triggers = {
    reg_token   = var.github_runner_registration_token
    private_key = sha1(file(local.vm_cluster.vms.github-runner.ssh_cfg.key_path))
  }

  connection {
    type        = "ssh"
    host        = nonsensitive(local.vm_cluster.vms.github-runner.ssh_cfg.host)
    user        = nonsensitive(local.vm_cluster.vms.github-runner.ssh_cfg.username)
    private_key = nonsensitive(file(local.vm_cluster.vms.github-runner.ssh_cfg.key_path))
  }

  provisioner "remote-exec" {
    inline = [templatefile("${local.init_scripts_dir}/github_runner.sh.tftpl", {
      reg_token   = nonsensitive(var.github_runner_registration_token)
      runner_name = "theproject-runner-${formatdate("YYYYMMDDhhmmss", timestamp())}"
    })]
  }
}


# resource "null_resource" "github_runner_docker" {
#   triggers = {
#     private_key = sha1(file(local.vm_cluster.vms.github-runner.ssh_cfg.key_path))
#   }

#   connection {
#     type        = "ssh"
#     host        = nonsensitive(local.vm_cluster.vms.github-runner.ssh_cfg.host)
#     user        = nonsensitive(local.vm_cluster.vms.github-runner.ssh_cfg.username)
#     private_key = nonsensitive(file(local.vm_cluster.vms.github-runner.ssh_cfg.key_path))
#   }

#   provisioner "remote-exec" {
#     script = "${local.init_scripts_dir}/install_docker.sh"
#   }
# }
