resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  version   = "v0.5.2"
  chart     = "stable/cert-manager"
  namespace = "${var.namespace}"
  keyring   = ""
}

data "template_file" "issuer" {
  template = "${file("${path.module}/files/issuer.yaml")}"

  vars {
    email_address = "${var.email_address}"
    domain = "${var.domain}"
    namespace = "${var.namespace}"
    google_project = "${var.google_project}"
  }
}

resource "local_file" "issuer" {
  content  = "${data.template_file.issuer.rendered}"
  filename = "${path.cwd}/ssl/issuer.yaml"
}
