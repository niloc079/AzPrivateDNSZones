#
# Find and replace environment short name
# Update CIDE for VNET
# Implies peer to hub and using hub gateway
#

locals {
    mgtnet-rg               = "mgtnet-rg"
    mgtnet-vnet             = "mgtnet-vnet"
    mgt-address-space       = ["10.225.0.0/16"]
}

resource "azurerm_resource_group" "mgtnet-rg" {
    name                    = local.mgtnet-rg
    location                = var.location
}

#VNET
resource "azurerm_virtual_network" "mgtnet-vnet" {
  name                = local.mgtnet-vnet
  location            = azurerm_resource_group.mgtnet-rg.location
  resource_group_name = local.mgtnet-rg
  address_space       = local.mgt-address-space
  #dns_servers         = []
}

#VNET Peer to Hub
resource "azurerm_virtual_network_peering" "mgtnet-vnet-to-hub" {
  name                         = "${local.mgtnet-vnet}-to-Hub"
  resource_group_name          = azurerm_resource_group.hubnet-rg.name
  virtual_network_name         = azurerm_virtual_network.hubnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.mgtnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

#VNET Peer from Hub
resource "azurerm_virtual_network_peering" "hub-to-mgtnet-vnet" {
  name                         = "Hub-to-${local.mgtnet-vnet}"
  resource_group_name          = azurerm_resource_group.mgtnet-rg.name
  virtual_network_name         = azurerm_virtual_network.mgtnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hubnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#Private DNS Zone Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zones_link_mgt" {
  for_each              = local.private_dns_zones
  name                  = azurerm_virtual_network.mgtnet-vnet.name
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.mgtnet-vnet.id
}