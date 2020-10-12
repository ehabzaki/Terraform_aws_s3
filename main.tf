provider "aws"{
    region = "us-east-2"
    access_key = ""
    secret_key = ""  

}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}
module "s3-week" {
    source = "./modules/s3/"
      bucket   = "berlin-week"
      acl    = "private"

  versioning = [{
    enabled    = true
  }]

  lifecycle_rule = [
    {
      id                                     = "week"
      enabled                                = true
      prefix                                 = "week"
      abort_incomplete_multipart_upload_days = null
      tags = {
        "rule"      = "week"

      }

      expiration = []
      transition = []
      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
      ]
      noncurrent_version_expiration = []
    },
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}


module "s3-day" {
    source = "./modules/s3/"
      bucket   = "berlin-day"
      acl   = "private"
  versioning = [{
    enabled    = true
  }]

}

module "s3-hour" {
    source = "./modules/s3/"
      bucket   = "berlin-hour"
      acl   = "private"
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }




  lifecycle_rule = [
    {
      id                                     = "hours"
      enabled                                = true
      prefix                                 = ""
      tags                                   = {}
      abort_incomplete_multipart_upload_days = 0
      expiration = [
        {
          days = 180
          date = []
          expired_object_delete_marker = false
        }
      ]
      noncurrent_version_expiration = []
      transition                    = []
      noncurrent_version_transition = []
    },
   ]
  versioning = [{
    enabled    = true
  }]

}