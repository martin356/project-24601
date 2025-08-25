terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }
  }

  backend "local" {}
}


provider "kubernetes" {
  host = local.vms_init.k3s_url

  client_certificate     = base64decode(local.vms_init.k3s_cers.client_certificate)
  client_key             = base64decode(local.vms_init.k3s_cers.client_key)
  cluster_ca_certificate = base64decode(local.vms_init.k3s_cers.cluster_ca_certificate)
}


provider "helm" {
  kubernetes = {
    host = local.vms_init.k3s_url

    client_certificate     = base64decode(local.vms_init.k3s_cers.client_certificate)
    client_key             = base64decode(local.vms_init.k3s_cers.client_key)
    cluster_ca_certificate = base64decode(local.vms_init.k3s_cers.cluster_ca_certificate)
  }
}
