resource "aws_s3_bucket" "nops_system_bucket" {
  count         = local.create_bucket ? 1 : 0
  bucket        = var.system_bucket_name
  force_destroy = false

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }

  depends_on = [time_sleep.wait_for_iam_role]
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
