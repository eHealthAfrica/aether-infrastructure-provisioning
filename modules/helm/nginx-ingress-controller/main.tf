resource "helm_release" "nginx-ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  namespace = "kube-system"

  set {
    name = "controller.extraArgs.v"
    value = "3"
  }

   values    = [
    "${file("${path.module}/files/values.yaml")}"
  ]

}
