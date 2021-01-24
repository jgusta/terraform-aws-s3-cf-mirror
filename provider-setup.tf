terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.15.0"
    }
  }
  required_version = "~> 0.14"
}

module "template_files" {
  source   = "apparentlymart/dir/template"
  version  = "1.0.2"
  base_dir = "${path.module}/src"
  template_vars = {
  }
}
  
provider "aws" {
  # Configuration options
  region     = "us-west-2"
  access_key = var.access_key_id
  secret_key = var.secret_access_key
}

provider "cloudflare" {
  api_token          = var.cloudflare_api_token
  api_client_logging = true
}
