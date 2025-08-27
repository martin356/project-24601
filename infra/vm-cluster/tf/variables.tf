variable "env" {
  type    = string
  default = "dev"
}


variable "network_cidr" {
  description = "Libvirt network interface cidr"
  type        = string
  default     = "192.168.130.0/24"
}
