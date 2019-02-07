resource "helm_repository" "eha" {
  name = "eha"
  url  = "https://ehealthafrica.github.io/helm-charts/"
}

data "template_file" "override" {
  template = "${file("${path.cwd}/overrides/${var.chart_name}.yaml")}"

  vars = {
    domain = "${var.domain}"
    project = "${var.project}"
    database_instance_name = "${var.database_instance_name}"
    gcs_bucket_credentials = "${var.gcs_bucket_credentials}"
    gcs_bucket_name = "${var.gcs_bucket_name}"
    dns_provider = "${var.dns_provider}"
  }
}

resource "helm_release" "service" {
  name      = "${var.chart_name}"
  chart     = "eha/${var.chart_name}"
  version   = "${var.chart_version}"
  namespace = "${var.namespace}"
  keyring   = ""
  values = [
    "${data.template_file.override.rendered}"
  ]
}
