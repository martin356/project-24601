module "istio" {
  source     = "./modules/istio"
  depends_on = [kubernetes_namespace.app]

  istio_cfg = local.istio_cfg
}


# module "trivy" {
#   source = "./modules/trivy"
#   depends_on = [
#     kubernetes_namespace.app,
#     module.istio
#   ]

#   namespace     = local.trivy_cfg.namespace
#   chart_version = local.trivy_cfg.chart_version
# }


