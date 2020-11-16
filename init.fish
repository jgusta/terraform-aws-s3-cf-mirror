#!/usr/bin/env fish
function _walk_vars
    set tfvars (awk '($0 ~ /variable/ ){ match($2,/"([^"]*)"/, arr); print arr[1]}' variables.tf)
    for i in $tfvars
        read --prompt-str=" $i = " resp
        echo "$i = \"$resp\"" >> terraform.tfvars
    end
end

pushd (dirname (readlink -m (status --current-filename)))

if not test -f terraform.tfvars
    _walk_vars
end

terraform init

popd