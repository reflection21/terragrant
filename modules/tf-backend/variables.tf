variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
}
variable "bucket_name" {
  description = "S3 bucket for holding Terraform state. Must be globally unique."
  type        = string
}
