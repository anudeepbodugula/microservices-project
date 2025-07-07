output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
  description = "Name of the S3 bucket used for Terraform state storage"
  
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "Name of the DynamoDB table used for Terraform state locking"
  
}