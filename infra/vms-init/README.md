## Overview
This infrastructure provisions initialisation of the VMs. It runs scripts on a VM which installs required packages, tools and set environment. Initialisation of the runner is optional. Terraform asks for input variable `registration token`. Since you do not have the registration token, leave the value empty.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.7.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.3.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5.3 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.7.2 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_config"></a> [config](#module\_config) | ../../config | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.init_scripts](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.github_runner](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.k3s_agent](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.k3s_server](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.k3s_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [external_external.k3s_kubeconfig](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [terraform_remote_state.vm_cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_github_runner_registration_token"></a> [github\_runner\_registration\_token](#input\_github\_runner\_registration\_token) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_k3s_cers"></a> [k3s\_cers](#output\_k3s\_cers) | Certicates exported from the kubeconfig |
| <a name="output_k3s_url"></a> [k3s\_url](#output\_k3s\_url) | n/a |
<!-- END_TF_DOCS -->
