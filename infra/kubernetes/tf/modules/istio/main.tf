resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = var.istio_cfg.namespace
  create_namespace = true
  version          = var.istio_cfg.chart_version

  values = [
    yamlencode({
      defaultRevision = "default"
    })
  ]
}


resource "helm_release" "istiod" {
  depends_on = [helm_release.istio_base]

  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = var.istio_cfg.namespace
  version    = var.istio_cfg.chart_version

  values = [
    yamlencode({
      meshConfig = {
        accessLogFile = "/dev/stdout"
      }
    })
  ]
}


# resource "helm_release" "istio_ingress" {
#   depends_on = [helm_release.istiod]

#   name             = "istio-ingress"
#   repository       = "https://istio-release.storage.googleapis.com/charts"
#   chart            = "gateway"
#   namespace        = var.istio_cfg.ingress_namespace
#   create_namespace = true
#   version          = var.istio_cfg.chart_version

#   values = [
#     yamlencode({
#       service = {
#         type = "NodePort"
#       }
#     })
#   ]
# }


# data "kubernetes_service_v1" "ingress_service" {
#   depends_on = [helm_release.istio_ingress]

#   metadata {
#     name      = helm_release.istio_ingress.name
#     namespace = var.istio_cfg.ingress_namespace
#   }
# }
