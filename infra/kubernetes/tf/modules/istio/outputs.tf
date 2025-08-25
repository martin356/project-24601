# locals {
#   http_nodeport  = try([for p in data.kubernetes_service_v1.ingress_service.spec[0].port : p.node_port if p.port == 80][0], null)
#   https_nodeport = try([for p in data.kubernetes_service_v1.ingress_service.spec[0].port : p.node_port if p.port == 443][0], null)
# }


# output "istio_gateway_nodeports" {
#   description = "NodePorts for Istio ingress gateway (http/https)."
#   value = {
#     http  = local.http_nodeport
#     https = local.https_nodeport
#   }
# }
