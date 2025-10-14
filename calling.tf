provider "aws" {
  region  = "ap-southeast-1"
  profile = "default"

  default_tags {
    tags = {
      Owner   = "darkmoon"
      Project = "Testing"
    }
  }
}


module "static_website" {
  source = "../s3-module" # Path to your module

  # Bucket configuration
  bucket_name         = "my-static-website"
  bucket_prefix       = "darkmoon"
  force_destroy       = true
  object_lock_enabled = false

  # Public access configuration for static website
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  skip_destroy            = false

  # ACL and ownership
  acl              = "public-read"
  object_ownership = "BucketOwnerPreferred"

  # Static website hosting configuration
  enable_static_website = true
  index_document        = "index.html"
  error_document        = "error.html"

  # Upload website files
  upload_website_files = true
  website_files = {
    "index.html" = {
      file_path    = "web/index.html"
      content_type = "text/html"
    }
    "error.html" = {
      file_path    = "web/error.html"
      content_type = "text/html"
    }
    # You can add more files like CSS, JS, images
    # "css/style.css" = {
    #   file_path    = "web/css/style.css"
    #   content_type = "text/css"
    # }
    # "images/logo.png" = {
    #   file_path    = "web/images/logo.png"
    #   content_type = "image/png"
    # }
  }

  # Bucket policy for public read access (required for static website)
  policy = data.aws_iam_policy_document.website_policy.json
}

# Bucket policy to allow public read access for static website
data "aws_iam_policy_document" "website_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${module.static_website.bucket_arn}/*"
    ]
  }
}

# Output the website URL
output "website_url" {
  description = "URL of the static website"
  value       = module.static_website.website_endpoint
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.static_website.bucket_id
}

output "website_domain" {
  description = "Domain of the static website"
  value       = module.static_website.website_domain
}
