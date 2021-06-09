resource "kubernetes_namespace" "twistlock" {
  metadata {
    name = "twistlock"
  }
}

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
    "service-parameter" = "${var.pcc_service-parameter}"



    //"ca.pem" = "${var.pcc_ca}"
    "ca.pem" = "-----BEGIN CERTIFICATE-----\nMIIDHTCCAgWgAwIBAgIRAO2ztjTYmdGK7Hzu47se9uEwDQYJKoZIhvcNAQELBQAw\nKDESMBAGA1UEChMJVHdpc3Rsb2NrMRIwEAYDVQQDEwlUd2lzdGxvY2swHhcNMjEw\nNjAyMTM0NzAwWhcNMjQwNjAxMTM0NzAwWjAoMRIwEAYDVQQKEwlUd2lzdGxvY2sx\nEjAQBgNVBAMTCVR3aXN0bG9jazCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC\nggEBALxfMUp4XG1U1chl9MTbtaCEOyjik7/Yi5yfO3lYwfZH2TIlBRCoucMQsUxB\nTWNze6zCkWZYv6BQE73ztHwWkRJT/LsIe7kWNy4XzAsOIYJMe4kNnLINeRIt3bUa\nGEDIvrTXMiE0CakrnKwdy7xfKArCekLAnMWtGxf6GcH/8Xivf02mt1+l6LSYYwDF\nYd1UQ5Ufaxa48cNsJZiDpkH4MSZKu98YnYmZAJ0/oE5z5RnVnxiSOu1EQWSCYom5\nS3hiRrDxzxDUmApv494vydKzSn/JCgXLCG1DngH/ssRFPOlIp8xy7p/wCZQw9xwZ\nQRZCx9GJVhmO4I5UFGqqMQ5cuS0CAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKsMA8G\nA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFCPNZSm3x6jCc1DeUXRfj21dKWZ1MA0G\nCSqGSIb3DQEBCwUAA4IBAQA4y4hRgeAYKjwINhO570upzmL8HsgtXakqIOwjVzSQ\nyHKH3+MeVxeaQaPFSOEv/wN9H2vU5lHPIdcKpiXDPA6A8SG/1ZbFEQXi64vJFfgr\nIBcL4qdjBXruhx4qLpbV+mcLSp7lvtwbQ4YD8FXAHaELuYdkeEt481XDyTZwMVfd\n72rS/+4G36WXxDn28uYnPo0DrxfnB0qCsQ3vp+jX8Y10xdPVa/PGx8mPJoP5y/Ho\nVX81RGksbq1NIjEpS8CJFYnYU/Sta3JCWI/rHttOujND8+3Iq0Zot9cn/vO5SCYa\n3UzK6VnpksFHsyQ+kGHswlLGRTQZtN1OjyhHO0GW/XBd\n-----END CERTIFICATE-----\n"

    //"client-cert.pem" = "${var.pcc_client-cert}"
    "client-cert.pem" = "-----BEGIN CERTIFICATE-----\nMIIDOzCCAiOgAwIBAgIQDieDOP0ZgMXA0Mly2lNbcDANBgkqhkiG9w0BAQsFADAo\nMRIwEAYDVQQKEwlUd2lzdGxvY2sxEjAQBgNVBAMTCVR3aXN0bG9jazAeFw0yMTA2\nMDIxNDAyMDBaFw0yNDA2MDExNDAyMDBaMCgxEjAQBgNVBAoTCVR3aXN0bG9jazES\nMBAGA1UEAxMJbG9jYWxob3N0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC\nAQEAxBUveAD1T1sP9MrLFFIOqK2F44LJZW8sznrAd0NMa2/2gmKNGzNrFzTwHT6l\niCqluVWM6oHVmlEdrtCcfy8gYtUxC7Y9LgxGaUyHVCvcCzss0IJo3tBQIApBi3HF\nvIjKUcC3wiIQ+PLexl7fTnQiZjAZULYPopVGFXlyuelYb5Hce5S7diYzR5vcToow\nW2lsFe1nPN66AZuaVipOUKj8XKSm/6Q2u/LFlmzacYbxc+JoTMVZLqpuWiW36rEe\n8sns8IvbU+EJ5Uf/u6oWkSoW2Eysg25wWQlosvwfQNMcPPe7+6E9pnBRrPsnLRVp\nv0eVl/si/CDUMRa73PWyWfeyqQIDAQABo2EwXzAOBgNVHQ8BAf8EBAMCB4AwEwYD\nVR0lBAwwCgYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBQjzWUp\nt8eownNQ3lF0X49tXSlmdTAJBgUqBAECBwQAMA0GCSqGSIb3DQEBCwUAA4IBAQAU\n4B1oY+XAC+F60XIYlV8SbIoNnwrwGPBJDNhNTtfvL7+o92Cc0itdbraiO69La5F1\nBkDzSM3fbtWB/fLZiNS8o3Dal7LRhfbVYKvnVFIxqR/MOKtk3IN7NGe2JnalTGx+\nhMSt5QVe+tO8gCNXb9pnC6++Wu0sdOxcd+xag+uIlU+MAv1KdXNlAJztpyxJYl6a\nDqXe4cRYLIs3VHB165+lkdjA99GTzkimbatj8t4O5Fsdwop67X6avROknBsuelb0\n3zICC4vl6RsOnoXoqxNiEF/lnbHAKtvwvLtFZAJ5IqObbHK9KCsvPmYk8HAOAf/J\n6Uy+gAhyM70wYFIIjZt8\n-----END CERTIFICATE-----\n"

    "client-key.pem" = "${var.pcc_client-key}"
    //"client-key.pem" = "-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-256-CBC,8859acb816180f8749547be477352ce7\n\nMCIB5tH0u45hCNovWi6rwEtBqxdMuIECqDmcmUnhHuSIf8QEl2F+sVaU09FitdEX\ntiXuqg8PDLHYFtvnMiiKuZtxx99ecJkHvgyStZ6tIVhrzm9kTYgfzYFhUNv8dnI/\n0kRtKruzN+c9i3+ZcakidaCbA75mET+GeVtAs3O77WvGmTmcogCCsGpKa3T3WvV+\nWtAy2lp8W3K0ESC3hzow95ADGenm8sT7/N/+dXOonWEMeK8HMRZMG5UQOZUE8yYl\ndc1avgSyk4tKiV5obUjIs/IbFOR1o/qbZWq7zoYHjAVydPb7jnuxEy9UOcqOALWZ\nY86B1koOoZ7ggRJpMvTFP4DjGilXSrBWy/HQPz2eiCoHxFm/y/nY7kdd5VUVwnds\n3KY9A8RQQxPh1grunJkc/OlxhQE+Cplaum+JBNJYVvTZSEpWNpBLJyiEyrfZ+Av+\nak+EBHR0iwiRsU+LMoKGwgdYsfyHhtmH7ephoPMxOhEgbs/5cO7mxEXKqtDaMZnE\nYn5WgAMT+gpH41K8gyyIGlrdAZNsJ3iThc6K96f4i61KIxu1YY/YGVxXVYGL1YIq\nW4613wvZs8jNfSr41cG2FR6NFEDUXmVy2EzxKGT+t6ceoSQWVDpFmV+MTlDGp6ei\nYIdQSiP19CgVw1C6unuxo7nsnrPwEjldc8NYX4/IA6JKuIgbz9oJPBsG17ouyFoP\nQkUfGlVJT1VgwKj4wGQTN6I4oDYDKWMfINrhmZk5KLQl/t09SIsJQHfryNR4wjsr\nqxDBDzkU4rpEkYKQHSAmGu31sI4yDNkJnDgnmaGa7/AKOtKEk0MIGjk4htiohpHU\nRdNYxspgrYCfFRZ87sIEZBZs7LuNOfQqHeCf8S4tfVeBUXcxvT+4Q9k56VPd0isS\n5Ugn/kQMBOa1pPAOt2sSUpX8JZBHpfGjbMpXWh2VeBcMMQBzu1ZLVHWv4D5/8XEL\nPFerpFfBxy/UxKKmb3pGPnXjXWQluVJgyGS0pacHuzwd9AF7yCk2UmxUPnSSvbaZ\n6H7CdBFuUaBpanlHgpMUF6vk2Ril+28PK/rC6PerGSbSxvSmEtaC0qx1mUhRXIFP\navFY8+g4YfsddzcvfS1YOHycFVLWLKRdxgDqNIGEeHtkp6ZpaIJ6a7h9F8JThC25\nWTDCjNus9YIOEhqJg5GmZBkc4pWmQ/7EeuyC4wfh6epyAVIJ/vuQkyexawbXXi7E\nvvH9MEuu1Zjwz1paq2h8mjQBLO5Q2zuSfECqRBxQYSkGSk5/WsrH2I4jSMNr6c4P\n5hBpLxA9RnAZJ+FTI+dyt2HEHhGErz0OPnfmn4sBJjXJ+KB7UFEREIyaoGsfoCpj\nwBYHiQU/VAVmsQwYQe5m4WvhgRePygjEGjhdweG3lVaU0nRicT5yMjkIQsS+2b+N\n5yF2oq4wnSxjH3DVnKPyxZiXyXXVaYWfJiFdzABfO2MVqtVHCOUe2el8IhB/J/Ue\ngm0EfA4Qv4qJ/CHW0ZQpc8HKAUuPh6faclCNhzflCWKYtYXtEmxQsOOYC9QC2Jn4\nbqleTf1O5Ua2KoXm5k1RYGuy0PwJVGZES7h1tnWfuDW+1Sn2UoX1IP9MeAClY6l9\n-----END RSA PRIVATE KEY-----\n"



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
          //image = "registry-auth.twistlock.com/tw_fqpwkggy0nlmjnhxfpz6kqqqym2jqpfn/twistlock/defender:defender_21_04_421"
          image = "${var.pcc_image}"

          env {
            name  = "WS_ADDRESS"
            //value = "wss://pcc.ng20.org:8084"
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
