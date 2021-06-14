resource "aws_ebs_volume" "sock-shop" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    App = "Sock-Shop"
  }
}

/*
resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = "pv"
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
        volume_id       = aws_ebs_volume.sock-shop.id
      }
    }
  }
}
*/