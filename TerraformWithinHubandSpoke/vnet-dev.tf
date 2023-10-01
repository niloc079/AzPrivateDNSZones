#
# Find and replace environment short name
# Update CIDE for VNET
# Implies peer to hub and using hub gateway
#

locals {
    devnet-rg               = "devnet-rg"
    devnet-vnet             = "devnet-vnet"
    dev-address-space       = ["10.223.0.0/16"]
}

#Resource Group
resource "azurerm_resource_group" "devnet-rg" {
    name                    = local.devnet-rg
    location                = var.location
}

#VNET
resource "azurerm_virtual_network" "devnet-vnet" {
  name                = local.devnet-vnet
  location            = vazurerm_resource_group.devnet-rg.location
  resource_group_name = local.devnet-rg
  address_space       = local.dev-address-space
  #dns_servers         = []
}

#VNET Peer to Hub
resource "azurerm_virtual_network_peering" "devnet-vnet-to-hub" {
  name                         = "${local.devnet-vnet}-to-Hub"
  resource_group_name          = azurerm_resource_group.hubnet-rg.name
  virtual_network_name         = azurerm_virtual_network.hubnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.devnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

#VNET Peer from Hub
resource "azurerm_virtual_network_peering" "hub-to-devnet-vnet" {
  name                         = "Hub-to-${local.devnet-vnet}"
  resource_group_name          = azurerm_resource_group.devnet-rg.name
  virtual_network_name         = azurerm_virtual_network.devnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hubnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#Private DNS Zone Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zones_link_dev" {
  for_each              = local.private_dns_zones
  name                  = azurerm_virtual_network.devnet-vnet.name
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.devnet-vnet.id
}
