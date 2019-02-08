data "aws_route53_zone" "domain" {
  name = "${var.domain}."
}

data "template_file" "values" {
  template = "${file("${path.module}/files/values.tmpl.yaml")}"

  vars {
    zone_id = "${data.aws_route53_zone.domain.zone_id}"
    aws_region = "${var.aws_region}"
    aws_secret_key = "${var.aws_secret_access_key}"
    aws_access_key = "${var.aws_access_key_id}"
  }
}

resource "helm_release" "external-dns" {
  name      = "external-dns"
  chart     = "stable/external-dns"
  namespace = "kube-system"
  version   = "1.3.3"
  keyring   = ""
  values    = [
    "${data.template_file.values.rendered}"
  ]
}

resource "kubernetes_secret" "secret" {
  metadata {
    name = "route53-credentials-${var.domain}"
    namespace = "kube-system"
  }

  data {
    secret = "${var.aws_secret_access_key}"
  }
}

output "aws_access_key_id" {
  value = "${var.aws_access_key_id}"
}
