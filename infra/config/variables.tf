variable "env" {
  type = string

  validation {
    condition     = contains(local.allowed_envs, var.env)
    error_message = "Allowed environments: ${join(",", local.allowed_envs)}. Current value: ${var.env}"
  }
}


variable "project" {
  type = string

  validation {
    condition     = length(var.project) > 1
    error_message = "Min length of project name is 2 characters"
  }
}
