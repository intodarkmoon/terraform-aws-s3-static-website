# ==============================================================================
# s3 bucket variables
# ==============================================================================

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = ""
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
  default     = ""
}

variable "bucket_prefix" {
  type        = string
  description = "Creates a unique bucket name beginning with the specified prefix."
  default     = ""
}

variable "force_destroy" {
  type        = bool
  description = "Force to delete the bucket even the bucket is not empty and prevent an error."
  default     = false
}

variable "object_lock_enabled" {
  type        = bool
  description = "Indicates whether this bucket has an Object Lock configuration enabled."
  default     = false
}

# ==============================================================================
# s3 bucket public access block
# ==============================================================================
variable "bucket" {
  type        = string
  description = "Bucket ID"
  default     = ""
}

variable "block_public_acls" {
  type        = bool
  description = "Block Public AcLs for the bucket"
  default     = false
}

variable "block_public_policy" {
  type        = bool
  description = "Block public bucket policies for the bucket."
  default     = false
}

variable "ignore_public_acls" {
  type        = bool
  description = "Ignore public ACLs for this bucket."
  default     = false
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = false
}

variable "skip_destroy" {
  type        = bool
  description = "Whether to retain the public access block upon destruction."
  default     = true
}


# ==============================================================================
# s3 bucket policy
# ==============================================================================
variable "policy" {
  type        = string
  description = "A valid policy JSON document."
  default     = ""
}


# ==============================================================================
# s3 bucket ownership controls
# ==============================================================================
variable "object_ownership" {
  type        = string
  description = "The Object Ownership setting that you want to apply to this bucket."
  default     = "BucketOwnerPreferred"
}


# ==============================================================================
# s3 bucket acl
# ==============================================================================
variable "acl" {
  type        = string
  description = "The canned ACL to apply. Defaults to 'private'."
  default     = "private"
}


# ==============================================================================
# s3 upload object
# ==============================================================================
variable "objects" {
  type        = list(string)
  description = "The object key for the uploaded object."
  default     = []

}
