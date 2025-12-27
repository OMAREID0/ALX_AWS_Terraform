## S3 bucket
resource "aws_s3_bucket" "s3_static_web" {
  bucket = "s3-bucket-staticwebsite-test"

  tags = {
    Name = "StaticWebsiteBucket"
  }
}

## Allow public access
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.s3_static_web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

## Ownership controls
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.s3_static_web.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]
}

## Bucket ACL
resource "aws_s3_bucket_acl" "public_acl" {
  bucket = aws_s3_bucket.s3_static_web.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership
  ]
}

## Static website hosting
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.s3_static_web.id

  index_document {
    suffix = "index.html"
  }
}

## Versioning
resource "aws_s3_bucket_versioning" "bucket_versions" {
  bucket = aws_s3_bucket.s3_static_web.id

  versioning_configuration {
    status = "Enabled"
  }
}

## Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.s3_static_web.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}
