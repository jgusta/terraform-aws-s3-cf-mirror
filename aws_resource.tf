resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
  tags = {
    Name = var.bucket_name
  }
}

locals {
  upload_files = {
    for key, value in module.template_files.files :
    key => value
    if basename(value.source_path) != ".gitignore"
  }
}

resource "aws_s3_bucket_object" "objects" {
  for_each     = local.upload_files
  bucket       = aws_s3_bucket.bucket.id
  key          = each.key
  source       = each.value.source_path
  content_type = each.value.content_type
  etag         = each.value.digests.md5
}

resource "aws_s3_bucket_policy" "restrict_to_cloudflare" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.restrict_to_cloudflare.json
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "logz.${var.bucket_name}"
  acl    = "log-delivery-write"
  tags = {
    Name = var.bucket_name
  }
}
