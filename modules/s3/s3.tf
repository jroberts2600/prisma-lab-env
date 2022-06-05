resource "aws_s3_bucket" "private-bucket" {
  bucket = "private-${random_string.suffix.id}"
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "private_versioning" {
  bucket = aws_s3_bucket.private-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
