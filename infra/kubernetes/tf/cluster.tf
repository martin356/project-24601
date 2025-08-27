resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
    labels = {
      env               = "dev"
      "istio-injection" = "enabled"
    }
  }
}


resource "kubernetes_manifest" "configmap" {
  manifest = local.manifests.configmap
}


resource "kubernetes_manifest" "deployment" {
  depends_on = [kubernetes_manifest.configmap]

  manifest = local.manifests.deployment
}


resource "kubernetes_manifest" "service" {
  depends_on = [kubernetes_manifest.deployment]

  manifest = local.manifests.service
}


resource "kubernetes_manifest" "ingress" {
  depends_on = [kubernetes_manifest.service]

  manifest = local.manifests.ingress
}
