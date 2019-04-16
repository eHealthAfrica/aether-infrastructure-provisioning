variable "chart_name" {}
variable "chart_version" {}
variable "namespace" {}
variable "domain" {}
variable "database_instance_name" {}
variable "gcs_bucket_credentials" { default="" }
variable "gcs_bucket_name" { default="" }
variable "dns_provider" {}

# Service URL's
variable "kernel_url" { default="" }
variable "odk_url" { default="" }
variable "gather_url" { default="" }
variable "ui_url" { default="" }

# Service database names
variable "odk_database_name" { default="" }
variable "ui_database_name" { default="" }
variable "gather_database_name" { default="" }
variable "kernel_database_name" { default="" }

# Service database users
variable "odk_database_user" { default="" }
variable "ui_database_user" { default="" }
variable "gather_database_user" { default="" }
variable "kernel_database_user" { default="" }

# bucket storage
variable "odk_bucket_name" { default="" }
variable "kernel_bucket_name" { default="" }
