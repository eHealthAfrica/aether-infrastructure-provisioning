provider "google" {
  project = "${var.google_project}"
  region  = "${var.google_region}"
  zone    = "${var.google_zone}"
}

provider "kubernetes" {
  host     = "${module.gke_cluster.cluster_endpoint}"
  username = "${var.admin_user}"
  password = "${var.admin_password}"

  client_certificate     = "${module.gke_cluster.client_certificate}"
  client_key             = "${module.gke_cluster.client_key}"
  cluster_ca_certificate = "${module.gke_cluster.cluster_ca_certificate}"
  load_config_file       = false
}

provider "helm" {
  install_tiller = true
  service_account = "tiller"
  kubernetes {
    host     = "${module.gke_cluster.cluster_endpoint}"
    username = "${var.admin_user}"
    password = "${var.admin_password}"

    client_certificate     = "${module.gke_cluster.client_certificate}"
    client_key             = "${module.gke_cluster.client_key}"
    cluster_ca_certificate = "${module.gke_cluster.cluster_ca_certificate}"
  }
}
