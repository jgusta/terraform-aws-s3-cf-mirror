#!/usr/bin/env fish
function _walk_vars
    set tfvars (awk '($0 ~ /variable/ ){ match($2,/"([^"]*)"/, arr); print arr[1]}' variables.tf)
    for i in $tfvars
        read --prompt-str=" $i = " resp
        echo "$i = \"$resp\"" >> terraform.tfvars
    end
end

if not test -f terraform.tfvars
    echo 'terraform.tfvars not found. Enter values.';
    _walk_vars
    echo 'terraform.tfvars created. Running init.';
else
    echo "terraform.tfvars found. Running init."
end

terraform init
