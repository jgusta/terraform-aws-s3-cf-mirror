'Free' (or at least cheap) static website deployment on a subdomain using S3, Cloudflare and Terraform. Emphasis on longevity.

## Requirements
- Local install of [Terraform CLI](https://www.terraform.io/downloads.html)
- Amazon S3 account
- A free-tier Cloudflare account
- A domain name with Cloudflare as nameserver
- Your static html

## Setup
- Put static website files in `src`, making sure you have at least `index.html`.
- Look at `variables.tf` to see what you need to define.
- Create your plan and apply:
```
terraform plan -out=.terraform/planfile && \
terraform apply .terraform/planfile
```

Result:
- Your static html files on an s3 bucket with:
  -  Static website feature enabled, not public.
  -  Contents are properly tagged with etag and content-type.
  -  An access policy that only allows Cloudflare IPs (automatically updated at deployment).
- A subdomain on cloudflare, which proxies the content of the bucket via CNAME.

In effect, you will have a static website hosted on S3, but served through Cloudflare's CDN, with the origin locked off. 

## Why host on S3 instead of Cloudflare pages? 
The idea of free static hosting has definitely lost a bit of its novelty due to the proliferation of static-site offerings. This template was started before Cloudflare pages was available. 

However there are a few reasons you might still be interested in this template's method. I made this template for archival of static websites with an emphasis on longevity, for example blogs of people who are no longer with us. You can see two archived sites deployed with this template: [Aaron Swartz' Blog](https://aaronsw.cloudgaffle.com/) and [Steve Steinberg's Blog](https://steinberg.cloudgaffle.com/). I consider these successful as of the original sites, the first no longer has SSL and the second is offline.
- S3 has a stable pricing structure that is unlikely to change. Even if they do away with the free tier, your costs will likely be be 1-2 cents per billing period (if this is your only aws costs, they wont bother to bill you).
- and Cloudflare's free offerings will likely always include Nameserver and CDN services, but Pages is still new. Using S3 for three years now, have still not paid anything for hosting of several static sites.




### Sources
- https://www.terraform.io/docs/configuration/modules.html
- https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
- https://advancedweb.hu/how-to-add-https-for-an-s3-bucket-website-with-cloudflare
- https://registry.terraform.io/modules/apparentlymart/dir/template/latest
