#Google GKE Cluster and Node Pool
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
  postgres_root_password = "${var.postgres_root_password}"
  database_instance_name = "${var.google_project}-v23"
  databases = ["${var.project}_odk","${var.project}_gather","${var.project}_kernel"]
  namespace = "${var.project}"
}

# Bucket storage
module "aether_odk_storage" {
  source = "../modules/gcs_bucket"
  gcs_bucket_name = "aether-odk-example-v2"
  gcs_bucket_credentials = "aether-odk-example-gcs-credentials"
  namespace = "${var.namespace}"
}

module "aether_kernel_storage" {
  source = "../modules/gcs_bucket"
  gcs_bucket_name = "aether-kernel-example-v2"
  gcs_bucket_credentials = "aether-kernel-example-gcs-credentials"
  namespace = "${var.namespace}"
}

# DNS IAM auth
module "iam-dns-aws" {
  source = "../modules/iam-dns-aws"
  cluster_name = "${var.namespace}"
  domain = "${var.domain}"
}
