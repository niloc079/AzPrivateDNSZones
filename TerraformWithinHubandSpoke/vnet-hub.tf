#
locals {
    hubnet-rg             = "hubnet-rg"
    hubnet-vnet           = "hubnet-vnet"
    hub-address-space     = ["10.220.0.0/16"]
}

resource "azurerm_resource_group" "hubnet-rg" {
  name     = local.hubnet-rg
  location = var.location
}

resource "azurerm_virtual_network" "hubnet-vnet" {
  name                = local.hubnet-vnet
  resource_group_name = azurerm_resource_group.hubnet-rg.name
  location            = azurerm_resource_group.hubnet-rg.location
  address_space       = local.hub-address-space
  #dns_servers         = []
}

#Private DNS Zone Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zones_link_hub" {
  for_each              = local.private_dns_zones
  name                  = azurerm_virtual_network.hubnet-vnet.name
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.hubnet-vnet.id
}
