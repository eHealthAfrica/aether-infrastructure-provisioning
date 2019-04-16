data "template_file" "values" {
  template = "${file("${path.module}/files/values.tpl.yaml")}"
  vars = {
    prometheus_name = "${var.prometheus_name}"
  }
}

resource "helm_release" "nginx-ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  namespace = "kube-system"

  set {
    name = "controller.extraArgs.v"
    value = "3"
  }

   values    = [
    "${data.template_file.values.rendered}"
  ]

}
