resource "google_service_account" "bucket" {
  account_id   = "${var.gcs_bucket_name}-gcs"
  display_name = "Service account for GCS"
}

resource "google_storage_bucket" "store" {
  name     = "${var.gcs_bucket_name}"
  location = "EU"
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.store.name}"
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bucket.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = "${google_service_account.bucket.name}"
}


# service account key key_namee
resource "local_file" "bucket_creds" {
  content  =<<EOF
variable "bucket_credentials" { default="${google_service_account_key.key.private_key}" }
EOF
  filename = "${path.cwd}/services/bucket_creds.tf"
}
