resource "kubernetes_cluster_role" "dashboard" {
  metadata {
    name = "kubernetes-dashboard-minimal"
  }

  rule {
    api_groups = [""]
    resources =  ["pods", "configmaps",
                  "deployments", "persistentvolumeclaims",
                  "replicationcontrollers", "replicationcontrollers/scale",
                  "serviceaccounts", "services", "nodes", "persistentvolumeclaims",
                  "persistentvolumes" ]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources = ["bindings", "events", "limitranges", "namespaces/status",
                 "pods/log", "pods/status", "replicationcontrollers/status",
                 "resourcequotas", "resourcequotas/status"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources = ["namespaces"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["apps"]
    resources = ["daemonsets", "deployments", "deployments/scale", "replicasets",
                 "replicasets/scale", "statefulsets"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["batch"]
    resources = ["cronjobs", "jobs"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["autoscaling"]
    resources = ["horizontalpodautoscalers"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources = ["services/proxy"]
    resource_names = ["heapster", "http:heapster:", "https:heapster:"]
    verbs = ["get"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["networkpolicies"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources = ["storageclasses", "volumeattachments"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources = ["clusterrolebindings", "clusterroles", "roles", "rolebindings"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
    verbs = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources = ["services/proxy"]
    resource_names = ["heapster", "http:heapster:", "https:heapster:"]
    verbs = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "dashboard" {
  metadata {
    name = "kubernetes-dashboard-minimal"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "kubernetes-dashboard-minimal"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.dashboard.metadata.0.name}"
    api_group = ""
    namespace = "${kubernetes_service_account.dashboard.metadata.0.namespace}"
  }
}

resource "kubernetes_service_account" "dashboard" {
  metadata {
    name = "kubernetes-dashboard-minimal"
    namespace = "kube-system"
  }
}

resource "helm_release" "kubernetes-dashboard" {
  name      = "kubernetes-dashboard"
  chart     = "stable/kubernetes-dashboard"
  namespace = "kube-system"
  keyring   = ""
}

resource "helm_release" "metrics" {
  name = "kubernetes-state-metrics"
  chart = "stable/kube-state-metrics"
  namespace = "kube-system"
}
