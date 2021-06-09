resource "kubernetes_namespace" "twistlock" {
  metadata {
    name = "twistlock"
  }
}
/*
resource "kubernetes_cluster_role" "twistlock_view" {
  metadata {
    name = "twistlock-view"
  }

  rule {
    verbs      = ["list"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]
  }

  rule {
    verbs      = ["list"]
    api_groups = ["security.istio.io"]
    resources  = ["authorizationpolicies", "peerauthentications"]
  }

  rule {
    verbs      = ["list"]
    api_groups = ["networking.istio.io"]
    resources  = ["virtualservices", "destinationrules", "gateways"]
  }

  rule {
    verbs      = ["list"]
    api_groups = [""]
    resources  = ["pods", "endpoints", "services"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["pods/proxy"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["namespaces", "pods"]
  }
}

resource "kubernetes_cluster_role_binding" "twistlock_view_binding" {
  metadata {
    name = "twistlock-view-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "twistlock-service"
    namespace = "twistlock"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "twistlock-view"
  }
}

resource "kubernetes_secret" "twistlock_secrets" {
  metadata {
    name      = "twistlock-secrets"
    namespace = "twistlock"
  }

  data = {
    "admission-cert.pem" = "${var.pcc_admission-cert}"

    "admission-key.pem" = "${var.pcc_admission-key}"

    "ca.pem" = "${var.pcc_ca}"

    "client-cert.pem" = "${var.pcc_client-cert}"

    "client-key.pem" = "${var.pcc_client-key}"

    service-parameter = "${var.pcc_service-parameter}"
  }

  type = "Opaque"
}

resource "kubernetes_service_account" "twistlock_service" {
  metadata {
    name      = "twistlock-service"
    namespace = "twistlock"
  }

  secret {
    name = "twistlock-secrets"
  }
}

resource "kubernetes_daemonset" "twistlock_defender_ds" {
  metadata {
    name      = "twistlock-defender-ds"
    namespace = "twistlock"
  }

  spec {
    selector {
      match_labels = {
        app = "twistlock-defender"
      }
    }

    template {
      metadata {
        labels = {
          app = "twistlock-defender"
        }

        annotations = {
          "container.apparmor.security.beta.kubernetes.io/twistlock-defender" = "unconfined"
        }
      }

      spec {
        volume {
          name = "certificates"

          secret {
            secret_name  = "twistlock-secrets"
            default_mode = "0400"
          }
        }

        volume {
          name = "syslog-socket"

          host_path {
            path = "/dev/log"
          }
        }

        volume {
          name = "data-folder"

          host_path {
            path = "/var/lib/twistlock"
          }
        }

        volume {
          name = "docker-netns"

          host_path {
            path = "/var/run/docker/netns"
          }
        }

        volume {
          name = "passwd"

          host_path {
            path = "/etc/passwd"
          }
        }

        volume {
          name = "docker-sock-folder"

          host_path {
            path = "/var/run"
          }
        }

        volume {
          name = "auditd-log"

          host_path {
            path = "/var/log/audit"
          }
        }

        volume {
          name = "iptables-lock"

          host_path {
            path = "/run"
          }
        }

        container {
          name  = "twistlock-defender"
          image = "${var.pcc_image}"

          env {
            name  = "WS_ADDRESS"
            value = "wss://${var.pcc_ws}"
          }

          env {
            name  = "DEFENDER_TYPE"
            value = "daemonset"
          }

          env {
            name  = "DEFENDER_LISTENER_TYPE"
            value = "none"
          }

          env {
            name  = "LOG_PROD"
            value = "true"
          }

          env {
            name  = "SYSTEMD_ENABLED"
            value = "false"
          }

          env {
            name  = "DOCKER_CLIENT_ADDRESS"
            value = "/var/run/docker.sock"
          }

          env {
            name  = "DEFENDER_CLUSTER_ID"
            value = "84239bbc-72b6-4182-7a7e-b09ed5fcd2ed"
          }

          env {
            name = "DEFENDER_CLUSTER"
          }

          env {
            name  = "MONITOR_SERVICE_ACCOUNTS"
            value = "true"
          }

          env {
            name  = "MONITOR_ISTIO"
            value = "true"
          }

          env {
            name  = "COLLECT_POD_LABELS"
            value = "true"
          }

          env {
            name  = "INSTALL_BUNDLE"
            value = "eyJzZWNyZXRzIjp7fSwiZ2xvYmFsUHJveHlPcHQiOnsiaHR0cFByb3h5IjoiIiwibm9Qcm94eSI6IiIsImNhIjoiIiwidXNlciI6IiIsInBhc3N3b3JkIjp7ImVuY3J5cHRlZCI6IiJ9fSwibWljcm9zZWdDb21wYXRpYmxlIjpmYWxzZX0="
          }

          env {
            name  = "HOST_CUSTOM_COMPLIANCE_ENABLED"
            value = "false"
          }

          resources {
            limits = {
              cpu    = "900m"
              memory = "512Mi"
            }

            requests = {
              cpu = "256m"
            }
          }

          volume_mount {
            name       = "data-folder"
            mount_path = "/var/lib/twistlock"
          }

          volume_mount {
            name       = "certificates"
            mount_path = "/var/lib/twistlock/certificates"
          }

          volume_mount {
            name       = "docker-sock-folder"
            mount_path = "/var/run"
          }

          volume_mount {
            name       = "passwd"
            read_only  = true
            mount_path = "/etc/passwd"
          }

          volume_mount {
            name       = "docker-netns"
            read_only  = true
            mount_path = "/var/run/docker/netns"
          }

          volume_mount {
            name       = "syslog-socket"
            mount_path = "/dev/log"
          }

          volume_mount {
            name       = "auditd-log"
            mount_path = "/var/log/audit"
          }

          volume_mount {
            name       = "iptables-lock"
            mount_path = "/run"
          }

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW", "SYS_ADMIN", "SYS_PTRACE", "SYS_CHROOT", "MKNOD", "SETFCAP"]
            }

            privileged                = true
            read_only_root_filesystem = true
          }
        }

        restart_policy       = "Always"
        dns_policy           = "ClusterFirstWithHostNet"
        service_account_name = "twistlock-service"
        host_network         = true
        host_pid             = true
      }
    }
  }
}

resource "kubernetes_service" "defender" {
  metadata {
    name      = "defender"
    namespace = "twistlock"

    labels = {
      app = "twistlock-defender"
    }
  }

  spec {
    port {
      port        = 443
      target_port = "9998"
    }

    selector = {
      app = "twistlock-defender"
    }
  }
}
*/