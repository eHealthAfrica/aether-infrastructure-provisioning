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

resource "local_file" "key_name" {
  content  =<<EOF
variable "aws_access_key_id" { default="${aws_iam_access_key.dns.id}" }
variable "aws_secret_access_key" { default="${aws_iam_access_key.dns.secret}" }
EOF
  filename = "${path.cwd}/services/dns_iam.tf"
}
