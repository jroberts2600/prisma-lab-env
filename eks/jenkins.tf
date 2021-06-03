resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

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
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          image = "jenkins/jenkins:lts-jdk11"
          name = "jenkins"
          port {
            container_port = 8080
          }
          volume_mount {
            name = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
        }
        volume {
          name = "jenkins-home"
          empty_dir {
            
          }
        }
      }
    }
  }
}

resource "kubernetes_service" jenkins {
  metadata {
    name = "jenkins"
    namespace = kubernetes_namespace.jenkins.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.jenkins.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}