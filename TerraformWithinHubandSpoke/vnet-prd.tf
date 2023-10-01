#
# Find and replace environment short name
# Update CIDE for VNET
# Implies peer to hub and using hub gateway
#

locals {
    prdnet-rg               = "prdnet-rg"
    prdnet-vnet             = "prdnet-vnet"
    prd-address-space       = ["10.221.0.0/16"]
}

#Resource Group
resource "azurerm_resource_group" "prdnet-rg" {
    name                    = local.prdnet-rg
    location                = var.location
}

#VNET
resource "azurerm_virtual_network" "prdnet-vnet" {
  name                = local.prdnet-vnet
  location            = azurerm_resource_group.prdnet-rg.location
  resource_group_name = local.prdnet-rg
  address_space       = local.prd-address-space
  #dns_servers         = []
}

#VNET Peer to Hub
resource "azurerm_virtual_network_peering" "prdnet-vnet-to-hub" {
  name                         = "${local.prdnet-vnet}-to-Hub"
  resource_group_name          = azurerm_resource_group.hubnet-rg.name
  virtual_network_name         = azurerm_virtual_network.hubnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.prdnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

#VNET Peer from Hub
resource "azurerm_virtual_network_peering" "hub-to-prdnet-vnet" {
  name                         = "Hub-to-${local.prdnet-vnet}"
  resource_group_name          = azurerm_resource_group.prdnet-rg.name
  virtual_network_name         = azurerm_virtual_network.prdnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hubnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#Private DNS Zone Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zones_link_prd" {
  for_each              = local.private_dns_zones
  name                  = azurerm_virtual_network.prdnet-vnet.name
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.prdnet-vnet.id
}