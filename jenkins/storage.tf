/*
resource "kubernetes_storage_class" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }

  storage_provisioner = "ebs.csi.aws.com"

  mount_options       = ["debug"]
  volume_binding_mode = "Immediate"
}

resource "kubernetes_persistent_volume_claim" "ebs_claim" {
  metadata {
    name = "jenkins-pvc"
    namespace = kubernetes_namespace.jenkins.id
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "4Gi"
      }
    }

    storage_class_name = "ebs-sc"
  }
}


*/