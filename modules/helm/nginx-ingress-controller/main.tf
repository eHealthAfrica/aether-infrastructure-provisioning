resource "helm_release" "nginx-ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  namespace = "kube-system"

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name = "metrics.enabled"
    value = "true"
  }

  set {
    name = "controller.extraArgs.v"
    value = "3"
  }

  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}
