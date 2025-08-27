# Tech Stack

**KVM** as the virtualization technology:
- It is simple and lightweight to run on a Linux host
- It has a well-maintained [Terraform provider](https://registry.terraform.io/providers/nv6/libvirt/latest/docs) for automation
- It integrates well with cloud-init for VM initialization
- It is suitable for small-scale, reproducible environments like this **home lab**

**Terraform** as the Infrastructure-as-Code (IaC) tool:
- It has very wide support for different tools and platforms
- It allows me to manage **VMs (via KVM/libvirt)**, **k3s cluster installation**, and **Helm charts** all within a single tool
- Using one IaC tool keeps the setup **consistent, declarative, and reproducible**

**GitHub Actions** for CI/CD:
- It is **natively integrated** with GitHub
- It is **completely maintained by GitHub**

# Overview
Virtaul machines, k3s and helm are provisioned and maintained via terraform. There are 3 infra projects:
- [VM Cluster](./infra/vm-cluster/README.md)
- [VMs Init](./infra/vms-init/README.md)
- [Kubernetes](./infra/kubernetes/README.md)


The environment consists of 4 virtual machines:

| VM Name         | Role                      | Description                                                              |
|-----------------|---------------------------|--------------------------------------------------------------------------|
| `k3s-master`    | Kubernetes Control Plane  | Runs the k3s server (control plane + datastore)                          |
| `k3s-worker-1`  | Kubernetes Worker Node    | Runs workloads as part of the cluster                                    |
| `k3s-worker-2`  | Kubernetes Worker Node    | Runs workloads as part of the cluster                                    |
| `github-runner` | GitHub Actions Runner     | Self-hosted runner registered with GitHub for CI/CD pipelines            |

All machines run **Ubuntu 24.04 LTS (Noble Numbat)** unless specified otherwise.

# Setup Instructions
Set of one-time steps to get host client ready.
#### Check virtualisation support
```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```
- __0__ - not supported :(
- __>0__ - supported :)

#### Install dependencies
```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager genisoimage
```

#### Grant qemu permissions to the storage
```bash
sudo mkdir -p /etc/apparmor.d/abstractions/libvirt-qemu.d

echo "/var/lib/libvirt/images/** rwk," | sudo tee -a /etc/apparmor.d/abstractions/libvirt-qemu.d/override

sudo systemctl restart apparmor
```

# Deployment steps
## Using Ansible
As mentioned, github runner is not fully operational (because of tf states), I have added ansible playbook to deploy all three ingra projects. From repository root directory run:
```bash
ansible-playbook playbooks/deployment.yml
```
#### Update resolver
To make app.dev.theproject reachable from the host client. `vm-cluster` creates the script for this.
```bash
bash vm-cluster/update_dns_resolver.sh
```

## Over CLI
Change directory to the repozitory infra folder - `theproject-24601/infra`
#### Create VMs
```bash
bash scripts/init.sh vm-cluster
./scripts/apply.sh vm-cluster
```
#### Init VMs
Terraform asks for github runner registration token. The registration token is short lived (cca 1 hour).
```bash
bash scripts/init.sh vms-init
bash scripts/apply.sh vms-init
```
#### Kubernetes
```bash
bash scripts/init.sh kubernetes
bash scripts/apply.sh kubernetes
```
#### Update resolver
To make app.dev.theproject reachable from the host client. `vm-cluster` creates the script for this.
```bash
bash vm-cluster/update_dns_resolver.sh
```
#### Verify
This should return `hello there`. May take few seconds.
```bash
curl -k app.dev.theproject
```

# Improvments
The solution is just simple home lab, but let's list few improvments which should be implemented in ideal world. The reason there is not the best setup of some part is just to make debugging easier.
### Multi-environment
All terraform infra projects consumes environemnt input variable. However, the value is hard-coded in the init and apply scripts. Also, there is only single network range in the config. In multi-env setup, the config would be per env.

### Sensitive values
- All senstive values in terraform input variables or outputs must use `sensitive = true`.
- All missing `sensitive=true` or all `nonsensitive` functions are used just for debugging purpose.

### Login to the VMs
VM password should be generated in terraform and safely injected to the userdata template.

### TF code injection
Not all scripts are protected. The purpose is to avoid scenario where an attacker can inject code as terrafrom variable to a templae script or config file.
<br>Take a look to the scripts produced by `vm-cluster` infra - safe interpolation.

### Github runners
I have created self-hosted runner since I did not want to include another platform to the solution. However, it would be perfectly feasible (and nice) to have github runners hosted in AWS as CodeBuild projects. This optopn woudl also make easy to safely store github credentials and retrieve registration token with every new runner registration.

### Deployment automation
The lab was designed to enable automated deployments via GitHub actions (the reason of self hosted runner existence). However, I miss one detail - terraform states are stored locally. I reaslised this quite late so it is very probable this kubernetes deployment in github actions is not implemented. Libvirt terraform domain resource provides the way to share local directory with the VM.

### Conditionally create github runner VM
Currently, the github runner VM is created even in case it is not used. `vm-cluster` infra should consume an argument to enable/disable github runner VM creation.