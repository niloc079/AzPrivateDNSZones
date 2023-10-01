#
#Tags
output "environment" {
  value = var.environment
}

output "application" {
  value = var.application
}

output "Location" {
  value = var.location
}

output "iteration" {
  value = var.iteration
}

output "application_owner" {
  value = var.application_owner
}

output "deployment_source" {
  value = var.deployment_source
}

output "tags" {
  value = var.tags
}

#
# Values
output "iteration_id" {
  value = random_string.iteration_id
}

output "random_pet_name" {
  value = random_pet.random_pet_name
}

#
# Custom
