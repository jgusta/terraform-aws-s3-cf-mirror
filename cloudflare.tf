resource "cloudflare_record" "bucket_cname" {
  zone_id = var.cloudflare_zone_id
  name    = var.cloudflare_record_name
  value   = aws_s3_bucket.bucket.website_endpoint
  type    = "CNAME"
  ttl     = 1
  proxied = true
}