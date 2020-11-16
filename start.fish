#!/bin/env fish
terraform plan -out=.terraform/planfile && \
terraform apply .terraform/planfile