resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "cloudsql-instance-credentials"
    namespace = "${var.namespace}"
  }
  data {
    credentials.json = "${base64decode(var.service_account_private_key)}"
  }
}

# service account for bucket acccess
resource "kubernetes_secret" "google-bucket-credentials" {
  metadata {
    name = "${var.namespace}-bucket-credentials"
    namespace = "${var.namespace}"
  }
  data {
    credentials.json = "${var.bucket_credentials}"
  }
}

resource "kubernetes_secret" "db_password" {
  metadata {
    name = "database-credentials"
    namespace = "${var.namespace}"
  }

  data {
    host = "127.0.0.1"
    user = "${var.postgres_root_username}"
    password = "${var.postgres_root_password}"
  }
}
