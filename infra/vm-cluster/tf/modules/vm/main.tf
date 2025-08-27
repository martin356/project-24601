locals {
  resource_name_prefix = var.name
  vm_username          = var.vm_username
}


# resource "libvirt_volume" "vm_disk" {
#   name           = "${local.resource_name_prefix}-vim-disk"
#   pool           = var.cluster_pool_name
#   format         = "qcow2"
#   size           = 10 * 1024 * 1024 * 1024
#   base_volume_id = libvirt_volume.ubuntu.id
# }


resource "libvirt_volume" "ubuntu" {
  name   = "${local.resource_name_prefix}-ubuntu_2404.img"
  source = var.os_image_uri
  pool   = var.cluster_pool_name
}


resource "libvirt_cloudinit_disk" "userdata" {
  name = "${local.resource_name_prefix}-cloudinit.iso"
  user_data = templatefile("${path.module}/cloudinit/userdata.yml", {
    hostname = var.name
    ssh_key  = var.ssh_key
    username = local.vm_username
    mac_addr = var.network.mac_addr
  })
  pool = var.cluster_pool_name
}


resource "libvirt_domain" "vm" {
  name = var.name

  vcpu       = var.vcpus
  memory     = var.memory_mb
  qemu_agent = true

  # disk {
  #   volume_id = libvirt_volume.vm_disk.id
  # }

  disk {
    volume_id = libvirt_volume.ubuntu.id
    scsi      = "true"
  }

  disk {
    file = split(";", libvirt_cloudinit_disk.userdata.id)[0]
    # file = libvirt_cloudinit_disk.userdata.id
  }

  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_id     = var.network.net_id
    addresses      = [var.network.ip_addr]
    mac            = var.network.mac_addr
    wait_for_lease = true
  }

  boot_device {
    dev = ["hd"]
  }

  dynamic "filesystem" {
    for_each = var.filesystems

    content {
      source   = filesystem.value.source
      target   = filesystem.value.target
      readonly = filesystem.value.readonly
    }
  }
}


resource "null_resource" "dhcp_lease" {
  triggers = {
    net_id     = var.network.net_id
    mac        = libvirt_domain.vm.network_interface[0].mac
    hostname   = libvirt_domain.vm.network_interface[0].hostname
    vm_running = libvirt_domain.vm.running
    script     = sha1(file("${path.module}/scripts/dhcp_lease.sh"))
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    environment = {
      NET_NAME = var.network.net_name
      VM_MAC   = libvirt_domain.vm.network_interface[0].mac
      VM_IP    = var.network.ip_addr
      VM_NAME  = libvirt_domain.vm.network_interface[0].hostname
    }
    command = file("${path.module}/scripts/dhcp_lease.sh")
  }
}
