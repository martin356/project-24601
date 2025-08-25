terraform {
  required_version = "~> 1.12.0"

  backend "local" {}

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.3"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.0"
    }
  }
}


provider "random" {}


provider "null" {}

provider "local" {}
