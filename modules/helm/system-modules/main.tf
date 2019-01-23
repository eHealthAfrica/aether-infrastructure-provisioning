# Tiller account
resource "kubernetes_service_account" "tiller" {
  automount_service_account_token = true

  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-cluster-rule"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    api_group = ""
    namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  }
}

module "external-dns" {
  source = "../external-dns"
  domain = "${var.domain}"
  cluster_name = "${var.cluster_name}"
}

# Nginx ingress controller
module "nginx" {
  source = "../nginx-ingress-controller"
}

module "cert-manager" {
  source = "../cert-manager"
  domain = "${var.domain}"
}
