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
