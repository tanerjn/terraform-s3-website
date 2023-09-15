resource "aws_s3_bucket" "prod_media" {
  bucket = var.bucket_name
  acl = "private"
  
  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
  }

}

resource "aws_s3_bucket_cors_configuration" "prod_media" {
  bucket = aws_s3_bucket.prod_media.id  
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.prod_media.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_acl" "prod_media" {
    bucket = aws_s3_bucket.prod_media.id
    acl = "private"
    depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.prod_media.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "prod_media_bucket" {
    bucket = aws_s3_bucket.prod_media.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.example]
}


resource "aws_s3_bucket_object" "example_object" {
  bucket = aws_s3_bucket.prod_media.id
  key    = "index.html"
  source = "index.html"
}
