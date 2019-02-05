# Google GKE Cluster and Node Pool
module "gke_cluster" {
  source = "../modules/gke_cluster"
  google_zone = "${var.google_region}-b"
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
  database_instance_name = "${var.google_project}-v3"
  namespace = "${var.namespace}"
}

# Helm modules
module "system_modules" {
  source = "../modules/helm/system-modules"
  google_project = "${var.google_project}"
  google_zone = "${var.google_zone}"
  cluster_name = "${module.gke_cluster.cluster_name}"
  domain = "${var.domain}"
}

# Aether Kernel
module "aether_kernel_storage" {
  source = "../modules/gcs_bucket"
  gcs_bucket_name = "aether-kernel-example"
  gcs_bucket_credentials = "aether-kernel-example-gcs-credentials"
  namespace = "example" # UPDATE ME
}

# Aether
module "aether_kernel" {
  source = "../modules/helm/service"
  chart_name = "aether-kernel"
  chart_version = "1.2.0"
  namespace = "example" # UPDATE ME
  project = "example" # UPDATE ME
  domain = "${var.domain}"
  database_instance_name = "${module.postgres.database_instance_name}"
  gcs_bucket_name = "aether-kernel-example"
  gcs_bucket_credentials = "aether-kernel-example-gcs-credentials"
}

# Aether Kernel
module "aether_odk_storage" {
  source = "../modules/gcs_bucket"
  gcs_bucket_name = "aether-odk-example"
  gcs_bucket_credentials = "aether-odk-example-gcs-credentials"
  namespace = "example" # UPDATE ME
}

module "aether_odk" {
  source = "../modules/helm/service"
  chart_name = "aether-odk"
  chart_version = "1.2.0"
  namespace = "example" # UPDATE ME
  project = "example" # UPDATE ME
  domain = "${var.domain}"
  database_instance_name = "${module.postgres.database_instance_name}"
  gcs_bucket_name = "aether-kernel-example"
  gcs_bucket_credentials = "aether-kernel-example-gcs-credentials"
}

module "gather" {
  source = "../modules/helm/service"
  chart_name = "gather"
  chart_version = "3.1.0"
  namespace = "example" # UPDATE ME
  project = "example" # UPDATE ME
  domain = "${var.domain}"
  database_instance_name = "${module.postgres.database_instance_name}"
}
