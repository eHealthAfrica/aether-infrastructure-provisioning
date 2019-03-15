resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations {
      name = "${var.namespace}"
    }
    name = "${var.namespace}"
  }
}

# Helm modules
module "system_modules" {
  source = "../../modules/helm/system-modules"
  google_project = "${var.google_project}"
  google_zone = "${var.google_zone}"
  domain = "${var.domain}"
}

# Secrets
module "postgres_secrets" {
  source = "../../modules/secrets"
  namespace = "${var.namespace}"
  postgres_root_username = "${var.postgres_root_username}"
  postgres_root_password = "${var.postgres_root_password}"
  service_account_private_key = "${var.service_account_private_key}"
  bucket_credentials = "${var.bucket_credentials}"
}

# Aether
module "aether_kernel" {
  source = "../../modules/helm/service"
  chart_name = "aether-kernel"
  chart_version = "1.2.0"
  namespace = "${var.namespace}"
  project = "${var.namespace}"
  domain = "${var.domain}"
  dns_provider = "gcp"
  database_instance_name = "${var.database_instance_name}"
  gcs_bucket_name = "aether-kernel-example"
  gcs_bucket_credentials = "example-bucket-credentials"
}

module "aether_odk" {
  source = "../../modules/helm/service"
  chart_name = "aether-odk"
  chart_version = "1.2.0"
  namespace = "example" # UPDATE ME
  project = "example" # UPDATE ME
  domain = "${var.domain}"
  dns_provider = "gcp"
  database_instance_name = "${var.database_instance_name}"
  gcs_bucket_name = "aether-kernel-example"
  gcs_bucket_credentials = "example-bucket-credentials"
}

module "gather" {
  source = "../../modules/helm/service"
  chart_name = "gather"
  chart_version = "3.1.0"
  namespace = "example" # UPDATE ME
  project = "example" # UPDATE ME
  domain = "${var.domain}"
  dns_provider = "gcp"
  database_instance_name = "${var.database_instance_name}"
}
