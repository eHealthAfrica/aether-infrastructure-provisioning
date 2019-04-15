# Kubernetes admin credentials
variable "admin_password" { default="oa2zao0yeezau0xaeYe3oedu3aiphu" }
variable "namespace" { default="example" }
variable "admin_user" { default="admin" }

# Postgres application users
variable "odk_database_user" { default="odk_example" }
variable "gather_database_user" { default="gather_example" }
variable "kernel_database_user" { default="kernel_example" }

# Postgres application users
variable "odk_database_name" { default="odk_example" }
variable "gather_database_name" { default="gather_example" }
variable "kernel_database_name" { default="kernel_example" }

# domain where applications will reside
variable "domain" { default="example.aethertest.org"}
variable "root_domain" { default="aethertest.org"}

# Bucket storage
variable "kernel_bucket_name" { default="aether-kernel-example-v3" }
variable "odk_bucket_name" { default="aether-odk-example-v3" }

# Google specific
variable "google_project" { default="development-223016" }
variable "google_region" { default="eu-west1" }
variable "google_zone" { default="eu-west1-b" }
variable "google_additional_zones" { default="eu-west1-c" }

# Prometheus and AlertManager htauth
variable "monitoring_namespace" { default="monitoring" }
variable "monitoring_user" { default="monitoring" }
variable "monitoring_password" { default="mei7caiDohye" }

# Service URL's
variable "odk_url" { default="odk.example.aethertest.org" }
variable "kernel_url" { default="kernel.example.aethertest.org" }
variable "gather_url" { default="example.aethertest.org" }

# Helm chart versions
variable "gather_helm_chart_version" { default="3.1.0" }
variable "kernel_helm_chart_version" { default="1.2.0" }
variable "odk_helm_chart_version" { default="1.2.0" }
