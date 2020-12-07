# Terraform static host

## Initialize
- Put static website files in `src`, making sure you have at least `index.html`.
- If you have fish shell run `./init.fish` to interactively create `terraform.tfvars`, or ...
- ... look at `variables.tf` to see what you need to define.
- Create your plan and apply:
```
terraform plan -out=.terraform/planfile && \
terraform apply .terraform/planfile
```

## Sources
### Articles
- https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
- https://advancedweb.hu/how-to-add-https-for-an-s3-bucket-website-with-cloudflare
- https://registry.terraform.io/modules/apparentlymart/dir/template/latest
- https://medium.com/@kscloud/restrict-s3-bucket-access-to-cloudflare-ips-only-104583f6fc98

### First party documentation
- https://www.terraform.io/docs/configuration/modules.html
- https://www.terraform.io/docs/modules/composition.html
- https://www.terraform.io/docs/modules/sources.html