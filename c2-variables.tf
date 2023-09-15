# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"
}

# Input variable definitions

variable "bucket_name" {
  description = "Name of the S3 bucket. Must be Unique across AWS"
  type        = string
  default = "tanermetin"
}

variable "tags" {
  description = "Tages to set on the bucket"
  type        = map(string)
  default     = {
    Terraform = "true"
    #abcdef = "true"
    Environment = "dev"
    newtag1 = "tag_development"
    newtag2 = "tag_production"
  }
}

