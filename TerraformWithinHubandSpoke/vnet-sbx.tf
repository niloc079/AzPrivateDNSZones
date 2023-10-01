#
# Find and replace environment short name
# Update CIDE for VNET
# Implies peer to hub and using hub gateway
#

locals {
    sbxnet-rg               = "sbxnet-rg"
    sbxnet-vnet             = "sbxnet-vnet"
    sbx-address-space       = ["10.224.0.0/16"]
}

#Resource Group
resource "azurerm_resource_group" "sbxnet-rg" {
    name                    = local.sbxnet-rg
    location                = var.location
}

#VNET
resource "azurerm_virtual_network" "sbxnet-vnet" {
  name                = local.sbxnet-vnet
  location            = azurerm_resource_group.sbxnet-rg.location
  resource_group_name = local.sbxnet-rg
  address_space       = local.sbx-address-space
  #dns_servers         = []
}

#VNET Peer to Hub
resource "azurerm_virtual_network_peering" "sbxnet-vnet-to-hub" {
  name                         = "${local.sbxnet-vnet}-to-Hub"
  resource_group_name          = azurerm_resource_group.hubnet-rg.name
  virtual_network_name         = azurerm_virtual_network.hubnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.sbxnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

#VNET Peer from Hub
resource "azurerm_virtual_network_peering" "hub-to-sbxnet-vnet" {
  name                         = "Hub-to-${local.sbxnet-vnet}"
  resource_group_name          = azurerm_resource_group.sbxnet-rg.name
  virtual_network_name         = azurerm_virtual_network.sbxnet-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hubnet-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#Private DNS Zone Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zones_link_sbx" {
  for_each              = local.private_dns_zones
  name                  = azurerm_virtual_network.sbxnet-vnet.name
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.sbxnet-vnet.id
}
