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

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-bucket-${random_string.suffix.id}"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "private" {
  bucket = aws_s3_bucket.private-bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
