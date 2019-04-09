#Google GKE Cluster and Node Pool
module "gke_cluster" {
  source = "../modules/gke_cluster"
  google_zone = "${var.google_zone}"
  google_region = "${var.google_region}"
  google_project = "${var.google_project}"
  cluster_name = "foo" # UPDATE ME
  initial_node_count = 1
  admin_user = "admin"
  additional_zones = "${var.google_additional_zones}"
  admin_password = "${var.admin_password}" # UPDATE ME
}

module "gke_node_pool" {
  source = "../modules/gke_node_pool"
  cluster_name = "${module.gke_cluster.cluster_name}"
  google_zone = "${var.google_zone}"
  pool_name = "app-pool"
  node_count = 1
  cluster_node_type = "n1-standard-2"
  google_project = "${var.google_project}"
  cluster_node_disk_size = 20
  node_pool_role = "app"
}

module "postgres" {
  source = "../modules/postgres"
  google_project = "${var.google_project}"
  google_region = "${var.google_region}"
  postgres_root_password = "${var.postgres_root_password}"
  database_instance_name = "${var.database_instance_name}"
  namespace = "${var.namespace}"
}

module "google_dns" {
  source = "../modules/google_dns"
  root_domain = "${var.root_domain}"
}

# Bucket storage
module "aether_odk_storage" {
  source = "../modules/gcs_bucket"
  gcs_bucket_name = "${var.odk_bucket_name}"
  gcs_bucket_credentials = "${var.bucket_credentials}"
  namespace = "${var.namespace}"
}

module "aether_kernel_storage" {
  source = "../modules/gcs_bucket"
  gcs_bucket_name = "${var.kernel_bucket_name}"
  gcs_bucket_credentials = "${var.kernel_bucket_name}-credentials"
  namespace = "${var.namespace}"
}
