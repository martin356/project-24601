variable "name" {
  type = string
}


variable "description" {
  type    = string
  default = ""
}


variable "memory_mb" {
  type    = number
  default = 1024
}


variable "vcpus" {
  type    = number
  default = 1
}


variable "ssh_key" {
  type = string
}


variable "cluster_pool_name" {
  type = string
}


variable "os_image_uri" {
  type = string
}


variable "network" {
  type = object({
    net_id   = string
    net_name = string
    ip_addr  = string
    mac_addr = string
  })
}


variable "filesystems" {
  type = list(object({
    source   = string
    target   = string
    readonly = optional(bool, true)
  }))
}


variable "vm_username" {
  type = string
}
