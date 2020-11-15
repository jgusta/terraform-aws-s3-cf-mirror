terraform {
    required_providers {
        cloudflare =  {
            source = "cloudflare/cloudflare"
            version = "~> 2.0"
        }
        aws =  {
            source = "hashicorp/aws"
            version = "3.15.0"
        }
    }
}

variable "BUCKET_NAME" {
    type = string
}

variable "ACCOUNT_ID" {
    type = string
}

variable "USER_ID" {
    type = string
}

variable "ACCESS_KEY_ID" {
    type = string
}

variable "SECRET_ACCESS_KEY" {
    type = string
}

provider "aws" {
    # Configuration options
    region = "us-west-2"
    access_key = var.ACCESS_KEY_ID
    secret_key = var.SECRET_ACCESS_KEY
}

provider "cloudflare" {
    version = "~> 2.0"
}

data "cloudflare_ip_ranges" "cloudflare" {}

resource "aws_s3_bucket" "b" {
    bucket = var.BUCKET_NAME
    acl = "private"
    website {
        index_document = "index.html"
        error_document = "index.html"
    }

    tags =  {
        Name = var.BUCKET_NAME
    }
}

resource "aws_s3_bucket_policy" "b" {
    bucket = aws_s3_bucket.b.id
    policy = data.aws_iam_policy_document.restrict_to_cloudflare_ips.json
}

#
# Restricting only to IPv4 addresses. For IPv6 use data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks
#
data "aws_iam_policy_document" "restrict_to_cloudflare_ips" {
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
            test = "NotIpAddress"
            variable = "aws:SourceIp"
            values = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
        }
    }
}
