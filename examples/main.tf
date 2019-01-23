# Google GKE Cluster and Node Pool
module "gke_cluster" {
  source = "../modules/gke_cluster"
  google_zone = "eu-europe-1b"
  google_project = "${var.google_project}"
  cluster_name = "foo" # UPDATE ME
  initial_node_count = 1
  additional_zones = "${var.google_region}-c"
  admin_user = "admin"
  admin_password = "admin" # UPDATE ME
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
  postgres_password = "postgres_password" # UPDATE ME
}

# Helm modules
module "system_modules" {
  source = "../modules/helm/system-modules"
  domain = "foo.com" # UPDATE ME
  google_project = "${var.google_project}"
  google_zone = "${var.google_zone}"
  cluster_name = "${module.gke_cluster.cluster_name}"
  admin_user = "admin"
  admin_password = "admin" # UPDATE ME
}

# Aether
module "aether_kernel" {
  source = "../modules/helm/aether"
  chart_name = "aether-kernel"
  chart_version = "1.2.0"
  namespace = "example" # UPDATE ME
}

module "aether_odk" {
  source = "../modules/helm/aether"
  chart_name = "aether-kernel"
  chart_version = "1.2.0"
  namespace = "example" # UPDATE ME
}

module "gather" {
  source = "../modules/helm/aether"
  chart_name = "aether-kernel"
  chart_version = "3.1.0"
  namespace = "example" # UPDATE ME
}
