variable "client_certificate" {
  default = <<EOF
${client_certificate}
EOF
}


variable "client_key" {
  default = <<EOF
${client_key}
EOF
}

variable "cluster_ca_certificate" {
  default = <<EOF
${cluster_ca_certificate}
EOF
}
