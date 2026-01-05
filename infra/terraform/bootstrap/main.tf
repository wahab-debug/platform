locals {
  bucket_names = {
    for env in var.environments :
    env => "${var.project}-tfstate-${env}"
  }

  dynamodb_table_names = {
    for env in var.environments :
    env => "${var.project}-tflock-${env}"
  }
}

# Optional: KMS key for state encryption (only if use_kms=true)
resource "aws_kms_key" "tfstate" {
  count                   = var.use_kms ? 1 : 0
  description             = "KMS key for Terraform remote state encryption (${var.project})"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "tfstate" {
  count         = var.use_kms ? 1 : 0
  name          = "alias/${var.project}-tfstate"
  target_key_id = aws_kms_key.tfstate[0].key_id
}

# S3 buckets for remote state (one per environment)
resource "aws_s3_bucket" "tfstate" {
  for_each = local.bucket_names

  bucket = each.value
}

resource "aws_s3_bucket_versioning" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.use_kms ? "aws:kms" : "AES256"
      kms_master_key_id = var.use_kms ? aws_kms_key.tfstate[0].arn : null
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "tfstate" {
  for_each = aws_s3_bucket.tfstate

  bucket = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# DynamoDB tables for state locking (one per environment)
resource "aws_dynamodb_table" "tflock" {
  for_each = local.dynamodb_table_names

  name         = each.value
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}
