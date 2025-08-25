resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}


resource "local_sensitive_file" "ssh_private" {
  filename             = "${path.module}/.ssh/${local.ssh_key_name}"
  content              = tls_private_key.ssh.private_key_openssh
  file_permission      = "0600"
  directory_permission = "0700"
}


resource "local_file" "ssh_public" {
  filename        = "${path.module}/.ssh/${local.ssh_key_name}.pub"
  content         = tls_private_key.ssh.public_key_openssh
  file_permission = "0644"
}
