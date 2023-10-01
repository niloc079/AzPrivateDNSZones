rm -recurse -force .terraform
rm -recurse -force .terraform.lock.hcl
rm -recurse -force terraform.tfstate
rm -recurse -force terraform.tfstate.backup
rm -recurse -force providers*
rm -recurse -force .infracost
move providers.blank.tfx providers.blank.tf