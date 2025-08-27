## Overview
This project provisions a **multi-VM home lab environment** using **KVM/libvirt** and **Terraform**.

- All configuration is defined in [`tf/config.tf`](./tf/config.tf)
- Terraform also generates **helper scripts** to manage them via `virsh`
    - start_vms.sh
    - stop_vms.sh
    - clean_vms.sh
    - update_dns_resolver.sh
- Default netwrok CIDR is 192.168.130.0/24

## Access to the machines

There two ways to login into to the VM. Machines must not share keys or credentials - they do jsut because it makes debugging far easier.
Password is hard-coded in the userdata - should be generated in TF and injected to the template (like k3s token in kubernetes infra)

### SSH
Terraform generates ssh key and stores it in the `.ssh` dir in the vm-cluster root folder. All machines share the same key.
```bash
ssh -i .infra/vm-cluster/tf/.ssh/theproject-dev-libvirt ubuntu@192.168.130.9
```

### virsh console
Using `virsh console` - all machines share the same credentials (username=ubuntu, pw=ubuntu)
```bash
virsh console theproject-dev-master
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12.0 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | ~> 0.8.3 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.4 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | ~> 0.8.3 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_config"></a> [config](#module\_config) | ../../config | n/a |
| <a name="module_vm"></a> [vm](#module\_vm) | ./modules/vm | n/a |

## Resources

| Name | Type |
|------|------|
| [libvirt_network.cluster](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/network) | resource |
| [libvirt_pool.cluster](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/pool) | resource |
| [local_file.script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh_public](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"dev"` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Libvirt network interface cidr | `string` | `"192.168.130.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_dns_domain"></a> [app\_dns\_domain](#output\_app\_dns\_domain) | Base domain of the running web application |
| <a name="output_master_vm"></a> [master\_vm](#output\_master\_vm) | Filtered master VM attributes from all VMs (single object) |
| <a name="output_vms"></a> [vms](#output\_vms) | A map of all created VMs with their metadata including ssh config, netwrok |
| <a name="output_worker_vms"></a> [worker\_vms](#output\_worker\_vms) | Filtered worker VMs attributes from all VMs (list of objects) |
<!-- END_TF_DOCS -->
