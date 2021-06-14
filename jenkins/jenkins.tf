resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

/*
resource "kubernetes_deployment" jenkins {
  metadata {
    name = "jenkins"
    namespace = kubernetes_namespace.jenkins.id
    labels = {
      app = "jenkins"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    volume {
      name = "jenkins-home"

      persistent_volume_claim {
        claim_name = "jenkins-pvc"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
    }

    spec {
      container {
        //image = "jenkins/jenkins:lts-jdk11"
        image = "public.ecr.aws/q6t7l4t3/jenkins-tf:0.2"
        name = "jenkins"
        port {
          container_port = 8080
        }
        volume_mount {
          name = "jenkins-home"
          mount_path = "/var/jenkins_home"
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.id

    labels = {
      name = "jenkins"
    }
  }

  spec {
    port {
      port        = 80
      target_port = 8080
    }

    selector = {
      app = "jenkins"
    }

    type = "LoadBalancer"
  }
}
*/
resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/nginx_status"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}