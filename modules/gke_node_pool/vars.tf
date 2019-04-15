#
variable "oauth_scopes" {
	description = "Node pool oauth scopes"
	default = [
		"compute-rw",
    "storage-rw",
    "logging-write",
    "monitoring",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite"
	]
}

variable "google_project" {}
variable "google_zone" {}
variable "cluster_name" {}
variable "pool_name" {}
variable "cluster_node_type" {}
variable "cluster_node_disk_size" {}
variable "node_count" {}
variable "node_pool_role" {}
