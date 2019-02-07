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

# service account key key_namee
resource "local_file" "key_name" {
  content  =<<EOF
variable "database_instance_name" { default="${google_sql_database_instance.master.connection_name}" }
variable "service_account_private_key" { default="${google_service_account_key.key.private_key}" }
variable "postgres_root_username" { default="postgres" }
variable "postgres_root_password" { default="${var.postgres_root_password}" }
EOF
  filename = "${path.cwd}/services/postgres_vars.tf"
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
