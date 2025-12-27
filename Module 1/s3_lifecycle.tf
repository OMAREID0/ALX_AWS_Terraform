resource "aws_s3_bucket_lifecycle_configuration" "website" {
  bucket = aws_s3_bucket.s3_static_web.id

  rule {
    id     = "move-noncurrent-to-ia"
    status = "Enabled"
    filter {}
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
  }

  rule {
    id     = "expire-noncurrent-after-365"
    status = "Enabled"
    filter {}
    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.bucket_versions
  ]
}
