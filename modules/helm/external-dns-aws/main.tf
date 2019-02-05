resource "aws_iam_user" "dns" {
  name = "external-dns-gcp-${var.domain}-${var.cluster_name}"
}

data "aws_route53_zone" "domain" {
  name = "${var.domain}."
}

data "template_file" "iam" {
  template = "${file("${path.module}/files/external-dns.tmpl.json")}"

  vars {
    zone_id = "${data.aws_route53_zone.domain.zone_id}"
  }
}

resource "aws_iam_access_key" "dns" {
  user = "${aws_iam_user.dns.name}"
}

resource "aws_iam_user_policy" "dns" {
  name = "external-dns-gcp-${var.domain}-${var.cluster_name}"
  user = "${aws_iam_user.dns.name}"

  policy = "${data.template_file.iam.rendered}"
}

data "template_file" "values" {
  template = "${file("${path.module}/files/values.tmpl.yaml")}"

  vars {
    zone_id = "${data.aws_route53_zone.domain.zone_id}"
    aws_region = "${var.aws_region}"
    aws_secret_key = "${aws_iam_access_key.dns.secret}"
    aws_access_key = "${aws_iam_access_key.dns.id}"
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
    secret = "${aws_iam_access_key.dns.secret}"
  }
}

output "aws_access_key_id" {
  value = "${aws_iam_access_key.dns.id}"
}
