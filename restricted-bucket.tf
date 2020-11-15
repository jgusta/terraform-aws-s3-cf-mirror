terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.15.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-west-2"
}

provider "cloudflare/cloudflare" {}

data "cloudflare_ip_ranges" "cloudflare" {}

resource "aws_s3_bucket" "static-bucket" {
  bucket = var.BUCKET_NAME
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = var.BUCKET_NAME
  }
}


#
# Restricting only to IPv4 addresses. For IPv6 use data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks
#
data "aws_iam_policy_document" "restrict-to-cloudflare-ips" {
  statement {
    sid = "RestrictToCloudflareIPs"

    actions = [
      "s3:*"
    ]

    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.BUCKET_NAME}",
      "arn:aws:s3:::${var.BUCKET_NAME}/*"
    ]

    not_principals {
      type = "*"
      identifiers = [
        "arn:aws:iam::${var.ACCOUNT_ID}:root",
        "arn:aws:iam::${var.ACCOUNT_ID}:user/&{aws:username}"
      ]
    }

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
    }
  }
}

resource "aws_s3_bucket_policy" "static-bucket" {
  bucket = aws_s3_bucket[var.BUCKET_NAME].id
  policy = data.aws_iam_policy_document.restrict-to-cloudflare-ips.json
}