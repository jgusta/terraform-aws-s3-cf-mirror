#!/usr/bin/env fish

terraform plan -out=.terraform/planfile && \
echo "Running planfile automatically." && \
terraform apply .terraform/planfile && \
set -l site_url (terraform output deployed_site_url) && \
echo "Finished. Site can be viewed at:"
echo $site_url
