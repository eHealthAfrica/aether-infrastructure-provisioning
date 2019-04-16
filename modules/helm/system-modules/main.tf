# Dashboard
module "dashboard" {
  source = "../kubernetes-dashboard"
}

# external DNS GCP DNS
module "external-dns" {
  source = "../external-dns"
  root_domain = "${var.root_domain}"
  google_project = "${var.google_project}"
}

# Nginx ingress controller
module "nginx" {
  source = "../nginx-ingress-controller"
  prometheus_name = "${module.prometheus.name}"
}

# Cert-manager letsencrypt
module "cert-manager" {
  source = "../cert-manager"
  domain = "${var.domain}"
  google_project = "${var.google_project}"
}

# Prometheus monitoring
module "prometheus" {
  source = "../prometheus"
  domain = "${var.domain}"
  project = "${var.project}"
}
