variable "bucket"{
    type = string
    description = "bucket name"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("[^ ]-(week|hour|day)$", var.bucket))
    error_message = "The bucket_name value must be a valid bucket_name, ending with \"-week or -hour or -day\"."
  }
  
}

variable "acl"{
    type = string
    description = "acl"
}

// Lifecycle rules variables:

variable "lifecycle_rule" {
  description = "create lifcycle rules"
  type        = list(object({
    id                                     = string
    prefix                                 = string
    tags                                   = map(string)
    enabled                                = bool
    abort_incomplete_multipart_upload_days = number
    expiration = list(object({
      days = number
      expired_object_delete_marker = bool
    }))
    noncurrent_version_expiration = list(object({
      days = number
    }))
    transition = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_transition = list(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
}


# Versioning
variable "versioning" {
  description = "versioning configration"
  type        = list(map(string))
  default     = []
}

# SSE 
variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}
# acl grant
variable "grant" {
  description = "ACL policy grant. Conflicts with `acl`"
  type        = any
  default     = []
}