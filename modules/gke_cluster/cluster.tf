# GKE cluster
resource "google_container_cluster" "primary" {
  name    = "${var.cluster_name}"
  zone    = "${var.google_zone}"
  project = "${var.google_project}"
  network = "default"
  initial_node_count = "${var.initial_node_count}"

  additional_zones = [
    "${split(",", "${var.additional_zones}")}",
  ]

  master_auth {
    username = "${var.admin_user}"
    password = "${var.admin_password}"
  }

  # required if a new default pool is created
  remove_default_node_pool=true

}

# Kubernetes config
provider "kubernetes" {
  host     = "${google_container_cluster.primary.endpoint}"
  username = "${var.admin_user}"
  password = "${var.admin_password}"
  client_key = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
  client_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}

# Tiller account
resource "kubernetes_service_account" "tiller" {
  automount_service_account_token = true

  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-cluster-rule"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    api_group = ""
    namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  }
}

# Kubernetes config template
data "template_file" "config" {
  template = "${file("${path.module}/template/config.tmpl.tf")}"
  vars = {
    host     = "${google_container_cluster.primary.endpoint}"
    username = "${var.admin_user}"
    password = "${var.admin_password}"
    project  = "${var.google_project}"
    region   = "${var.google_region}"
    zone     = "${var.google_zone}"
  }
}

# Kubernetes config template
data "template_file" "auth" {
  template = "${file("${path.module}/template/auth_vars.tmpl.tf")}"
  vars = {
    client_key = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
    client_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
  }
}

# write Kubernees config provider
resource "local_file" "config" {
  content  = "${data.template_file.config.rendered}"
  filename = "${path.cwd}/services/config.tf"
}

# write certificates
resource "local_file" "auth" {
  content  = "${data.template_file.auth.rendered}"
  filename = "${path.cwd}/services/auth.tf"
}

resource "local_file" "endpoint" {
  content  = "variable \"cluster_name\" { default=\"${google_container_cluster.primary.name}\" }"
  filename = "${path.cwd}/services/cluster.tf"
}

# Outputs
output "cluster_name" {
  value = "${google_container_cluster.primary.name}"
}

# Public endpoint of the cluster
output "cluster_endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}

output "username" {
 value = "${var.admin_user}"
}

output "password" {
  value = "${var.admin_password}"
}
