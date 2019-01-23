# GKE Node pool
resource "google_container_node_pool" "pool" {
  name       = "${var.pool_name}"
  zone       = "${var.google_zone}"
  cluster    = "${var.cluster_name}"
  project    = "${var.google_project}"
  node_count = "${var.node_count}"

  node_config {
    preemptible  = false
    machine_type = "${var.cluster_node_type}"

    disk_size_gb = "${var.cluster_node_disk_size}"
    image_type = "COS"

    oauth_scopes = "${var.oauth_scopes}"
  }
}
