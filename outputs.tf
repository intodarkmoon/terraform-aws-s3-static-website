# =====================================================================================
# OUTPUTS
# =====================================================================================

output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.my-static-website.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.my-static-website.arn
}

output "bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = aws_s3_bucket.my-static-website.bucket_region
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.my-static-website.bucket_domain_name
}

output "website_endpoint" {
  description = "The website endpoint URL"
  value       = aws_s3_bucket.my-static-website.website_endpoint
}

output "website_domain" {
  description = "The domain of the website endpoint"
  value       = aws_s3_bucket.my-static-website.website_domain
}

output "uploaded_objects" {
  description = "List of uploaded objects"
  value       = keys(var.website_files)
}
