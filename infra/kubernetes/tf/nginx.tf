# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name = "nginx"
#   }
#   spec {
#     replicas = 1
#     selector {
#       match_labels = { app = "nginx" }
#     }
#     template {
#       metadata { labels = { app = "nginx" } }
#       spec {
#         container {
#           name  = "nginx"
#           image = "nginx:stable-alpine"
#           port { container_port = 80 }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "nginx" {
#   metadata {
#     name = "nginx"
#   }
#   spec {
#     selector = { app = "nginx" }
#     port {
#       port        = 80
#       target_port = 80
#     }
#     type = "ClusterIP"
#   }
# }
