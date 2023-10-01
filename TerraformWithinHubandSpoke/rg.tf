#
resource "azurerm_resource_group" "rg" {
  name        = "${var.environment}${var.application}${var.iteration}-rg"
  location    = var.location
  tags        = var.tags
}
