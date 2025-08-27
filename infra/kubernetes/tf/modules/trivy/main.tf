resource "kubernetes_manifest" "trivy_namespace" {
  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name = var.namespace
      labels = {
        "istio-injection" = "disabled"
      }
    }
  }
}


resource "helm_release" "trivy_operator" {
  depends_on = [kubernetes_manifest.trivy_namespace]

  name             = "trivy-operator"
  repository       = "https://aquasecurity.github.io/helm-charts"
  chart            = "trivy-operator"
  namespace        = var.namespace
  create_namespace = false
  version          = var.chart_version

  values = [
    yamlencode({
      trivy = {
        # Only show High/Critical at first; tweak later
        severity      = "HIGH,CRITICAL"
        ignoreUnfixed = true
      }

      operator = {
        configAuditScanner = {
          enabled = true
        }
        vulnerabilityScanner = {
          enabled = true
        }
        rbacAssessmentScanner = {
          enabled = true
        }
        scanJobsConcurrentLimit = 3
        scanJobTimeout          = "5m"
        targetNamespaces        = ""
      }

      serviceMonitor = {
        enabled = false
      }
    })
  ]

  wait    = true
  timeout = 600
}
