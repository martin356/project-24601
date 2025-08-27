locals {
  kubeconfig = yamldecode(base64decode(data.external.k3s_kubeconfig.result["content"]))
}


output "k3s_cers" {
  description = "Certicates exported from the kubeconfig"
  value = {
    client_certificate     = local.kubeconfig.users[0].user["client-certificate-data"]
    client_key             = local.kubeconfig.users[0].user["client-key-data"]
    cluster_ca_certificate = local.kubeconfig.clusters[0].cluster["certificate-authority-data"]
  }
  sensitive = true
}


output "k3s_url" {
  value = local.k3s_url
}
