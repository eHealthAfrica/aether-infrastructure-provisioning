# Dashboard
module "dashboard" {
  source = "../kubernetes-dashboard"
}

module "external-dns" {
  source = "../external-dns"
  domain = "${var.domain}"
  google_project = "${var.google_project}"
}

# Nginx ingress controller
module "nginx" {
  source = "../nginx-ingress-controller"
}

module "cert-manager" {
  source = "../cert-manager"
  domain = "${var.domain}"
  google_project = "${var.google_project}"
}
