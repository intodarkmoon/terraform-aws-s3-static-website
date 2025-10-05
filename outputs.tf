output "bucket_id" {
  value = aws_s3_bucket.my-static-website.id
}

output "bucket_region" {
  value = aws_s3_bucket.my-static-website.bucket_region
}

output "bucket_domain_name" {
  value = aws_s3_bucket.my-static-website.bucket_domain_name
}
