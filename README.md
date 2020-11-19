'Free' (or at least cheap) static website deployment on a subdomain using S3, Cloudflare and Terraform.

## This repo

This is a terraform config that describes:

1) An s3 bucket with the the static website feature enabled, but not public.
2) The contents are uploaded from the `src` directory.
3) The contents are properly tagged with etag and content-type.
4) The policy applied limits access exclusively to Cloudflare.
5) Cloudflare is identified by iv4 and iv6 IP addresses, automatically pulled from their api.
6) A subdomain on a Cloudflare , that proxies the content of the bucket via CNAME.

## Requirements

- MacOS / Unix like (i think)
- [Terraform CLI](https://www.terraform.io/downloads.html) 
- Amazon Web Services account (S3 specifically).
- A domain name that you own that is managed by your own free Cloudflare account.
- Your static html website that starts at `index.html` and can include subfolders.
- (Optional) [Fish Shell[(https://fishshell.com/) for running the 'do-it-for-me' scripts. You can at least read the scripts and know what it is doing

## Initialize
- Put static website files in `src`, making sure you have at least `index.html`.
- If you have fish shell run `./init.fish` to interactively create `terraform.tfvars`, or ...
- ... look at `variables.tf` to see what you need to define.
- Create your plan and apply:
```
terraform plan -out=.terraform/planfile && \
terraform apply .terraform/planfile
```

## Example
- Imagine I just crawled my wordpress site and saved it as html. 
- Im done with the dynamic backend and just want to preserve the site as a static snapshot. 
- I want it to be somewhere available and reliably safe and I also dont want to pay for hosting.
- I own a $10/year domain and I have a free Cloudflare account managing it.
- I dump the files into the `src` dir here, fill in the variables (or run `init.fish` to interactively do it) for my aws and Cloudflare accounts. 
- Then I use the free [Terraform](https://www.terraform.io/downloads.html) cli to run `plan` and/or `apply`. Being lazy I just run ./start.fish` which handles that for me.
- Now my site is available on the web at the subdomain I wanted and s3 hosts it for 1 cent a month (which if that's your only s3 usage means they don't bill you at all even on the non-free tier.) And Cloudflare caches all of that.



### Sources
- https://www.terraform.io/docs/configuration/modules.html
- https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
- https://www.terraform.io/docs/modules/sources.html
- https://advancedweb.hu/how-to-add-https-for-an-s3-bucket-website-with-cloudflare
- https://registry.terraform.io/modules/apparentlymart/dir/template/latest
