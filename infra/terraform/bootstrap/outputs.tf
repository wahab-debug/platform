output "tfstate_buckets" {
  description = "Remote state S3 buckets by environment"
  value       = { for env, b in aws_s3_bucket.tfstate : env => b.bucket }
}

output "tflock_tables" {
  description = "DynamoDB lock tables by environment"
  value       = { for env, t in aws_dynamodb_table.tflock : env => t.name }
}

output "kms_key_arn" {
  description = "KMS key ARN used for encryption (if enabled)"
  value       = var.use_kms ? aws_kms_key.tfstate[0].arn : null
}
