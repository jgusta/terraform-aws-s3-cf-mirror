output "deployed_site_url" {
  value = "https://${cloudflare_record.bucket_cname.hostname}"
}
