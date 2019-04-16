data "template_file" "values" {
  template = "${file("${path.module}/files/values.tpl.yaml")}"
  vars = {
    domain = "${var.domain}"
    project = "${var.project}"
  }
}

resource "helm_release" "prometheus-operator" {
  name      = "prometheus-operator"
  chart     = "stable/prometheus-operator"
  namespace = "${var.namespace}"
  keyring   = ""
  values = [
    "${data.template_file.values.rendered}"
  ]
}

output "name" {
  value = "${helm_release.prometheus-operator.name}"
}
