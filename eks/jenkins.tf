resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_deployment" jenkins {
  metadata {
    name = "jenkins"
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
            container_port = 80
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