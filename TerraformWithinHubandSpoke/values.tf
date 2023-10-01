#
resource "random_string" "iteration_id" {
  length  = 5
  lower   = true
  numeric = true
  min_numeric = 5
  special = false
  upper   = false
}

resource "random_pet" "random_pet_name" {
  length  = 1
}

data "azurerm_client_config" "current" {
}
