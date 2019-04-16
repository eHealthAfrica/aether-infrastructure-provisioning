provider "kubernetes" {
  host     = "${host}"
  username = "${username}"
  password = "${password}"

  client_certificate     = "$${var.client_certificate}"
  client_key             = "$${var.client_key}"
  cluster_ca_certificate = "$${var.cluster_ca_certificate}"
  load_config_file       = false
}

provider "helm" {
  install_tiller = true
  service_account = "tiller"
  kubernetes {
    host     = "${host}"
    username = "${username}"
    password = "${password}"

    client_certificate     = "$${var.client_certificate}"
    client_key             = "$${var.client_key}"
    cluster_ca_certificate = "$${var.cluster_ca_certificate}"
  }
}

provider "google" {
  project = "${project}"
  region  = "${region}"
  zone    = "${zone}"
}
