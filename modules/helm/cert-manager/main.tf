resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "stable/cert-manager"
  namespace = "${var.namespace}"
  keyring   = ""
}

data "template_file" "certificate" {
  template = "${file("${path.module}/files/certificate.yaml")}"

  vars {
    namespace = "${var.namespace}"
    domain = "${var.domain}"
  }
}

data "template_file" "issuer" {
  template = "${file("${path.module}/files/issuer.yaml")}"

  vars {
    email_address = "${var.email_address}"
    domain = "${var.domain}"
    namespace = "${var.namespace}"
  }
}

resource "local_file" "issuer" {
  content  = "${data.template_file.issuer.rendered}"
  filename = "${path.cwd}/ssl/issuer.yaml"
}
