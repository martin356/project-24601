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


variable "network_id" {
  type = string
}
