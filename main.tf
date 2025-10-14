# =====================================================================================
# MAIN
# =====================================================================================

resource "aws_s3_bucket" "my-static-website" {
  region              = var.region
  bucket              = var.bucket_name
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
}


resource "aws_s3_bucket_public_access_block" "block-public-access" {
  bucket                  = aws_s3_bucket.my-static-website.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  skip_destroy            = var.skip_destroy
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.my-static-website.id
  policy = var.policy
}


resource "aws_s3_bucket_ownership_controls" "ownership-controls" {
  bucket = aws_s3_bucket.my-static-website.id

  rule {
    object_ownership = var.object_ownership
  }

}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.my-static-website.id
  acl    = var.acl

  depends_on = [aws_s3_bucket_public_access_block.block-public-access]

}


resource "aws_s3_bucket_website_configuration" "website" {
  count = var.enable_static_website ? 1 : 0

  bucket = aws_s3_bucket.my-static-website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}


resource "aws_s3_object" "website-files" {
  for_each = var.upload_website_files ? var.website_files : {}

  bucket       = aws_s3_bucket.my-static-website.id
  key          = each.key
  source       = each.value.file_path
  etag         = filemd5(each.value.file_path)
  content_type = lookup(each.value, "content_type", null)

  depends_on = [
    aws_s3_bucket_acl.bucket-acl
  ]
}
