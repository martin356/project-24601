locals {
  resource_name_prefix = var.name
  vm_username          = "ubuntu"
}


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
  })
  pool = var.cluster_pool_name
}


resource "libvirt_domain" "vm" {
  name = var.name

  vcpu       = var.vcpus
  memory     = var.memory_mb
  qemu_agent = true

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
    network_id     = var.network_id
    wait_for_lease = true
  }

  boot_device {
    dev = ["hd"]
  }
}
