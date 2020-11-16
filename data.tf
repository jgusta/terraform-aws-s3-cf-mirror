data "cloudflare_ip_ranges" "cloudflare" {}

#
# Restricting only to IPv4 addresses. For IPv6 use data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks
#
data "aws_iam_policy_document" "restrict_to_cloudflare" {
  statement {
    sid = "RestrictToCloudflareIPs"

    actions = [
      "s3:GetObject"
    ]

    effect = "Allow"

    principals {
      type="*"
      identifiers = ["*"]
    }

    resources = [
      # "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = concat(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks,data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks, [])
    }
  }
}