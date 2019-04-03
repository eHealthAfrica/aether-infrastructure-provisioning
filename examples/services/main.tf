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
  project = "${var.namespace}"
}

# Secrets
module "secrets" {
  source = "../../modules/secrets"
  namespace = "${var.namespace}"
  postgres_root_username = "${var.postgres_root_username}"
  postgres_root_password = "${var.postgres_root_password}"
  service_account_private_key = "${var.service_account_private_key}"
  bucket_credentials = "${var.bucket_credentials}"
  monitoring_password = "${var.monitoring_password}"
  monitoring_user = "${var.monitoring_password}"
  monitoring_namespace = "${var.monitoring_namespace}"
}

# Aether
module "aether_kernel" {
  source = "../../modules/helm/service"
  chart_name = "aether-kernel"
  chart_version = "${var.kernel_helm_chart_version}"
  namespace = "${var.namespace}"
  domain = "${var.domain}"
  dns_provider = "gcp"
  database_instance_name = "${var.database_instance_name}"
  kernel_bucket_name = "${var.kernel_bucket_name}"
  gcs_bucket_credentials = "${var.kernel_bucket_name}-credentials"
  kernel_url = "${var.kernel_url}"
  kernel_database_name = "${var.kernel_database_name}"
  kernel_database_user = "${var.kernel_database_user}"
}

module "aether_odk" {
  source = "../../modules/helm/service"
  chart_name = "aether-odk"
  chart_version = "${var.odk_helm_chart_version}"
  namespace = "${var.namespace}"
  domain = "${var.domain}"
  dns_provider = "gcp"
  database_instance_name = "${var.database_instance_name}"
  odk_bucket_name = "${var.odk_bucket_name}"
  gcs_bucket_credentials = "${var.odk_bucket_name}-credentials"
  odk_url = "${var.odk_url}"
  odk_database_name = "${var.odk_database_name}"
  odk_database_user = "${var.odk_database_user}"
}

module "gather" {
  source = "../../modules/helm/service"
  chart_name = "gather"
  chart_version = "${var.gather_helm_chart_version}"
  namespace = "${var.namespace}"
  domain = "${var.domain}"
  dns_provider = "gcp"
  database_instance_name = "${var.database_instance_name}"
  kernel_url = "${var.kernel_url}"
  gather_url = "${var.gather_url}"
  gather_database_name = "${var.gather_database_name}"
  gather_database_user = "${var.gather_database_user}"
}
