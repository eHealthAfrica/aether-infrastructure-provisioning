# Dashboard
module "dashboard" {
  source = "../kubernetes-dashboard"
}

module "external-dns" {
  source = "../external-dns-aws"
  domain = "${var.domain}"
  cluster_name = "${var.cluster_name}"
  aws_access_key_id = "${var.aws_access_key_id}"
  aws_secret_access_key = "${var.aws_secret_access_key}"
}

# Nginx ingress controller
module "nginx" {
  source = "../nginx-ingress-controller"
}

module "cert-manager" {
  source = "../cert-manager"
  domain = "${var.domain}"
  aws_access_key_id = "${module.external-dns.aws_access_key_id}"
}
