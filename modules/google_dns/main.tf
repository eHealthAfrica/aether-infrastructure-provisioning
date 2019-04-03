# Create the DNS zone in Google
resource "google_dns_managed_zone" "zone" {
  name = "${element(split(".", var.root_domain), 0)}"
  dns_name = "${var.root_domain}."
  description = "DNS zone"
}
