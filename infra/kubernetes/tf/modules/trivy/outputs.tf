output "trivy_operator_namespace" {
  value = var.namespace
}


output "trivy_operator_release" {
  value = helm_release.trivy_operator.name
}
