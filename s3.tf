resource "aws_s3_bucket" "nops_system_bucket" {
  count         = local.create_bucket ? 1 : 0
  bucket        = local.system_bucket_name
  force_destroy = false

  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    nops_project.project
  ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "nops_bucket_encryption" {
  count  = local.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.nops_system_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "nops_bucket_block_public_access" {
  count  = local.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.nops_system_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "nops_bucket_policy" {
  count  = local.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.nops_system_bucket[0].id
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.nops_system_bucket[0].arn,
          "${aws_s3_bucket.nops_system_bucket[0].arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
  lifecycle {
    ignore_changes = all
  }
}
