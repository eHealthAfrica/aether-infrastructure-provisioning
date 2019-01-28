resource "helm_repository" "eha" {
  name = "eha"
  url  = "https://ehealthafrica.github.io/helm-charts/"
}

resource "helm_release" "service" {
  name      = "${var.chart_name}"
  chart     = "eha/${var.chart_name}"
  version   = "${var.chart_version}"
  namespace = "${var.namespace}"
  keyring   = ""
  values = [
    "${file("${path.cwd}/${var.chart_name}.yaml")}"
  ]
}
