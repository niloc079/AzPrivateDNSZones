#tf starting
terraform init
terraform init -upgrade

#tf validation
terraform validate
terraform fmt

#tf plan, apply, destroy
terraform.exe plan --var-file=env/hub.tfvars
terraform.exe apply --var-file=env/hub.tfvars
terraform.exe destroy --var-file=env/hub.tfvars

#tf import
terraform import --var-file=env/hub.tfvars azurerm_resource_group.rg /subscriptions/{subid}/resourceGroups/{yourrg}

#Cost
infracost breakdown --show-skipped --path .
infracost breakdown --show-skipped --path . --format html --out-file infracost.html
infracost breakdown --show-skipped --path . --format json --out-file infracost.json
