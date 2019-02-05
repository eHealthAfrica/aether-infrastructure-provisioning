resource "google_sql_database_instance" "master" {
  name = "${var.google_project}-${var.database_instance_name}"
  database_version = "${var.database_version}"
  region = "${var.google_region}"
  project = "${var.google_project}"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "${var.db_instance_type}"
    disk_size = "${var.database_size}"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled = "true"
    }
  }
}

resource "google_sql_user" "users" {
  name     = "${var.postgres_root_username}"
  instance = "${google_sql_database_instance.master.name}"
  password = "${var.postgres_root_password}"
  project = "${var.google_project}"
}

resource "google_service_account" "sql" {
  account_id = "postgres-${var.google_project}"
}

resource "google_project_iam_binding" "sql" {
  project = "${var.google_project}"
  role = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.sql.email}"
  ]
}

resource "google_service_account_key" "key" {
  service_account_id = "${google_service_account.sql.name}"
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "cloudsql-instance-credentials"
    namespace = "${var.namespace}"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.key.private_key)}"
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

output "db_ip" {
  value = "${google_sql_database_instance.master.first_ip_address}"
}

output "db_link" {
  value = "${google_sql_database_instance.master.self_link}"
}

output "database_instance_name" {
  value = "${google_sql_database_instance.master.connection_name}"
}


output "connection_name" {
  value = "${google_sql_database_instance.master.connection_name}"
}
