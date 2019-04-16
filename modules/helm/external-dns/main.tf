resource "google_service_account" "dns" {
  account_id = "external-dns"
  display_name   = "external-dns"
}

resource "google_project_iam_binding" "dns" {
  project = "${var.google_project}"
  role = "roles/dns.admin"
  members = [
    "serviceAccount:${google_service_account.dns.email}"
  ]
}

resource "google_service_account_key" "dns" {
  service_account_id = "${google_service_account.dns.name}"
}

data "template_file" "values" {
  template = "${file("${path.module}/files/values.tmpl.yaml")}"

  vars {
    root_domain = "${var.root_domain}"
    google_project = "${var.google_project}"
  }
}

resource "kubernetes_secret" "dns_private_key" {
  metadata {
    name = "clouddns-private-key"
    namespace = "kube-system"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.dns.private_key)}"
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
