
#Variables
$TenantId = "?Tenant ID?"
$SubscriptionId = "?az sub?"
$AzLoc1 = "Central US"
$AzLoc2 = ""
$AzDNSRG = "hub-dns-rg"
$AzVnetHubRG = "hub-net-rg"
$AzVnetProdRG = "prd-net-rg"
#

# Login
az login
Connect-AzAccount
Set-AzContext -SubscriptionId $SubscriptionId 

#Install Module
Install-Module -Name Az.PrivateDns -force

#
# Get Azure Locations
#
#get-azlocation | select location | Sort-Object location

#
# Create RG + PrivateDNS Zones
#
New-AzResourceGroup -Name $AzDNSRg -Location $AzLoc1

#
# Import CSV
#
$ZoneFile = Import-CSV -Path ".\AzPrivateDNSZonesList.txt"

#
# Create zones from file
#
$ZoneFile | ForEach {
  $Zones = New-AzPrivateDnsZone `
        -Name $_.Zones `
        -ResourceGroupName $AzDNSRG
}

#
# PDNS Link Hub
#
$vnethub = Get-AzVirtualNetwork -ResourceGroupName $AzVnetHubRG

$ZoneFile | ForEach {
  $ZoneLink = New-AzPrivateDnsVirtualNetworkLink `
          -ZoneName $_.Zones `
          -ResourceGroupName $AzDNSRG `
          -Name $AzVnetHubRG `
          -VirtualNetworkId $vnethub.id
}

#
# PDNS Link PRD
#
$vnetPrd = Get-AzVirtualNetwork -ResourceGroupName $AzVnetPrdRG

$ZoneFile | ForEach {
  $ZoneLink = New-AzPrivateDnsVirtualNetworkLink `
          -ZoneName $_.Zones `
          -ResourceGroupName $AzDNSRG `
          -Name $AzVnetPrdRG `
          -VirtualNetworkId $vnetPrd.id
}

#
# Get Something
#