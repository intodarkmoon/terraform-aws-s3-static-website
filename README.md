# Guidelines

Terraform module for provisioning an AWS S3 bucket configured for static website hosting.

## Example of Usage
### Folder Structure
```
project-a/
├── main.tf
├── web/
│   ├── index.html
│   └── error.html
└── outputs.tf
```

### Examples

```
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
  source  = "intodarkmoon/s3-static-website/aws"

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

```

## Requirements
| Name  | Version |
| ------------- |:-------------:|
| terraform      | >=1.0.0     |
| aws     | >=6.0.0     |

## Providers
| Name  | Version |
| ------------- |:-------------:|
| aws     | >=6.0.0     |

## Resources
| Resource | Type |
|----------|------|
| aws_s3_bucket.my-static-website | Resource |
| aws_s3_bucket_public_access_block.block-public-access | Resource |
| aws_s3_bucket_policy.bucket-policy | Resource |
| aws_s3_bucket_ownership_controls.ownership-controls | Resource |
| aws_s3_bucket_acl.bucket-acl | Resource |
| aws_s3_bucket_website_configuration.website | Resource |
| aws_s3_object.website-files | Resource |

## Inputs
| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | Region where this resource will be managed. Defaults to the Region set in the provider configuration. | string | `""` |
| bucket_name | Name of the bucket | string | `""` |
| bucket_prefix | Creates a unique bucket name beginning with the specified prefix. | string | `""` |
| force_destroy | Force to delete the bucket even the bucket is not empty and prevent an error. | bool | `false` |
| object_lock_enabled | Indicates whether this bucket has an Object Lock configuration enabled. | bool | `false` |
| bucket | Bucket ID | string | `""` |
| block_public_acls | Block Public AcLs for the bucket | bool | `false` |
| block_public_policy | Block public bucket policies for the bucket. | bool | `false` |
| ignore_public_acls | Ignore public ACLs for this bucket. | bool | `false` |
| restrict_public_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | bool | `false` |
| skip_destroy | Whether to retain the public access block upon destruction. | bool | `true` |
| policy | A valid policy JSON document. | string | `""` |
| object_ownership | The Object Ownership setting that you want to apply to this bucket. | string | `"BucketOwnerPreferred"` |
| acl | The canned ACL to apply. Defaults to 'private'. | string | `"private"` |
| enable_static_website | Whether to configure the bucket for static website hosting | bool | `false` |
| index_document | The name of the index document | string | `"index.html"` |
| error_document | The name of the error document | string | `"error.html"` |
| website_files | Map of website files to upload. Key is the object key in S3, value contains file_path and optional content_type | `map(object({ file_path = string, content_type = optional(string) }))` | `{}` |
| upload_website_files | Whether to upload website files | bool | `false` |


## Outputs
| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_region | The AWS region this bucket resides in |
| bucket_domain_name | The bucket domain name |
| website_endpoint | The website endpoint URL |
| website_domain | The domain of the website endpoint |
| uploaded_objects | List of uploaded objects |


## License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Complete license is available in the [LICENSE](https://github.com/intodarkmoon/terraform-aws-s3-static-website/blob/darkmoon/LICENSE) file.