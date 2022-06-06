resource "aws_s3_bucket" "marketing" {
  bucket = "marketing-${random_string.suffix.id}"
}

resource "aws_s3_bucket_acl" "marketing" {
  bucket = aws_s3_bucket.marketing.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "marketing" {
  bucket = aws_s3_bucket.marketing.id
  versioning_configuration {
    status = "Enabled"
  }
}

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

resource "aws_s3_bucket_server_side_encryption_configuration" "private_encryption" {
  bucket = aws_s3_bucket.private-bucket.id
  rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id = var.s3_key_arn
        sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-bucket-${random_string.suffix.id}"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "marketing" {
  bucket = aws_s3_bucket.marketing.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "marketing-log/"
}

resource "aws_s3_bucket_logging" "private" {
  bucket = aws_s3_bucket.private-bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "private-log/"
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.private-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  
}