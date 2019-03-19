# Create the DNS zone in Google
resource "google_dns_managed_zone" "zone" {
  name = "${var.domain}"
  dns_name = "${var.domain}"
  description = "DNS zone"
}
