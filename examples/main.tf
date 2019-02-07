# Google GKE Cluster and Node Pool
module "gke_cluster" {
  source = "../modules/gke_cluster"
  google_zone = "${var.google_region}-b"
  google_region = "${var.google_region}-b"
  google_project = "${var.google_project}"
  cluster_name = "foo" # UPDATE ME
  initial_node_count = 1
  admin_user = "admin"
  additional_zones = "${var.google_region}-c"
  admin_password = "${var.admin_password}" # UPDATE ME
}

module "gke_node_pool" {
  source = "../modules/gke_node_pool"
  cluster_name = "${module.gke_cluster.cluster_name}"
  google_zone = "${var.google_region}-b"
  pool_name = "app-pool"
  node_count = 1
  cluster_node_type = "n1-standard-1"
  google_project = "${var.google_project}"
  cluster_node_disk_size = 20
  node_pool_role = "app"
}

module "postgres" {
  source = "../modules/postgres"
  google_project = "${var.google_project}"
  google_region = "${var.google_region}"
  postgres_root_password = "Uechiu0ja4phaiB"
  database_instance_name = "${var.google_project}-v4"
  namespace = "${var.namespace}"
}
