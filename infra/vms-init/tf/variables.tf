variable "env" {
  type = string
}


variable "github_runner_registration_token" {
  description = "Github runner registration token. Leave empty in case the runner registration is not required"
  type        = string
  sensitive   = true
}
