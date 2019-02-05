resource "helm_release" "cert-manager" {
  name      = "cert-manager"
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
    aws_access_key_id = "${var.aws_access_key_id}"
  }
}

resource "local_file" "issuer" {
  content  = "${data.template_file.issuer.rendered}"
  filename = "${path.cwd}/ssl/issuer.yaml"
}
