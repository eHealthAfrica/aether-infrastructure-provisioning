resource "helm_release" "external-dns" {
  name      = "external-dns"
  chart     = "stable/external-dns"
  namespace = "kube-system"
  keyring   = ""
  values    = [
  "${file("${path.module}/files/values.yaml")}"
  ]
}
