#### Terraform Backend Configuration ####
provider "aws" {                            ## sepcify the AWS provider
    region = "ca-central-1"
  
}
################# S3 Bucket COnfiguration #########################
resource s3_bucket "terraform_state" {     ## create an S3 bucket for storing Terraform state
    bucket = "terraform-state-bucket-myapp-microservices"

    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_s3_bucket_versioning" "terraform_state" {  ## enable versioning for the S3 bucket
    bucket = s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {  ## apply server-side encryption to the S3 bucket
    bucket = s3_bucket.terraform_state.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
  
}
################## DynamoDB Table Configuration #########################
resource "aws_dynamodb_table" "terraform_locks" {      # create a DynamoDB table for state locking
    name        = "terraform-locks-myapp"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    lifecycle {
        prevent_destroy = false
    }
  
}
