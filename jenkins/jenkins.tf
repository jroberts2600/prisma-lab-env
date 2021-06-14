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
    volume {
      name = "jenkins-home"

      persistent_volume_claim {
        claim_name = "jenkins-pvc"
      }
    }
    replicas = 1
    /*
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
      */
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
