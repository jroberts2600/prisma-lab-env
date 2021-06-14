resource "aws_ebs_volume" "jenkins" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    App = "jenkins"
  }
}

resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = var.pv_name
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "gp2-retain"
    persistent_volume_source {
      aws_elastic_block_store {
        volume_id       = aws_ebs_volume.jenkins.id
      }
    }
  }
}

