data "template_file" "override" {
  template = "${file("${path.cwd}/overrides/${var.chart_name}.yaml")}"

  vars = {
    domain = "${var.domain}"
    database_instance_name = "${var.database_instance_name}"
    gcs_bucket_credentials = "bucket-credentials"
    kernel_bucket_name = "${var.kernel_bucket_name}"
    odk_bucket_name = "${var.odk_bucket_name}"
    dns_provider = "${var.dns_provider}"
    kernel_url = "${var.kernel_url}"
    odk_url = "${var.odk_url}"
    gather_url = "${var.gather_url}"
    ui_url = "${var.ui_url}"
    kernel_database_name = "${replace(var.kernel_database_name, "-", "_")}"
    odk_database_name = "${replace(var.odk_database_name, "-", "_")}"
    gather_database_name = "${replace(var.gather_database_name, "-", "_")}"
    ui_database_name = "${replace(var.ui_database_name, "-", "_")}"
    kernel_database_user = "${replace(var.kernel_database_name, "-", "_")}"
    odk_database_user = "${replace(var.odk_database_user, "-", "_")}"
    gather_database_user = "${replace(var.gather_database_user, "-", "_")}"
    ui_database_user = "${replace(var.ui_database_user, "-", "_")}"
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

# resource "local_file" "foo" {
#   content     = "${data.template_file.override.rendered}"
#   filename = "${path.cwd}/${var.chart_name}.yaml"
# }
