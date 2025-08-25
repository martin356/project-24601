locals {
  kubeconfig_path = "${path.module}/kubeconfig.yml"
  manifests_dir   = "${path.module}/templates"

  app_name = "theproject"
  namespaces = {
    app = "app"
  }

  configmap_manifest_cfg = {
    key      = "configmap"
    filename = "configmap.yml"
    vars = {
      namespace      = local.namespaces.app
      name           = local.app_name
      index_html_b64 = base64encode("hello there")
    }
  }

  deployment_manifest_cfg = {
    key      = "deployment"
    filename = "deployment.yml"
    vars = {
      namespace = local.namespaces.app
      name      = local.app_name
      image     = "nginx:1.25-alpine"
      replicas  = 1
    }
  }

  service_manifest_cfg = {
    key      = "service"
    filename = "service.yml"
    vars = {
      namespace = local.namespaces.app
      name      = local.app_name
      port      = 80
      node_port = 30080
    }

  }

  manifests = {
    for cfg in [
      local.configmap_manifest_cfg,
      local.deployment_manifest_cfg,
      local.service_manifest_cfg
    ] : cfg.key => yamldecode(templatefile("${path.module}/templates/${cfg.filename}", cfg.vars))
  }

  istio_cfg = {
    namespace         = "istio-system"
    ingress_namespace = "istio-ingress"
    chart_version     = "1.27.0"
  }


  trivy_cfg = {
    namespace     = "trivy-system"
    chart_version = "0.30.0"
  }
}


module "config" {
  source = "../../config"

  project = "kubernetes"
  env     = var.env
}
