
#Variables
$TenantId = "?Tenant ID?"
$SubscriptionId = "?az sub?"
$AzLocation = "Central US"
$AzDNSRG = "hub-dns-rg"
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
New-AzResourceGroup -Name $AzDNSRg -Location $AzLocation

#Zones
$ZoneArray = 
"privatelink.azure-automation.net",
"privatelink.database.windows.net",
"privatelink.centralus.database.windows.net",
"privatelink.sql.azuresynapse.net",
"privatelink.dev.azuresynapse.net",
"privatelink.azuresynapse.net",
"privatelink.blob.core.windows.net",
"privatelink.table.core.windows.net",
"privatelink.queue.core.windows.net",
"privatelink.file.core.windows.net",
"privatelink.web.core.windows.net",
"privatelink.dfs.core.windows.net",
"privatelink.documents.azure.com",
"privatelink.mongo.cosmos.azure.com",
"privatelink.cassandra.cosmos.azure.com",
"privatelink.gremlin.cosmos.azure.com",
"privatelink.table.cosmos.azure.com",
"privatelink.postgres.cosmos.azure.com",
"centralus.privatelink.batch.azure.com",
"centralus.service.privatelink.batch.azure.com",
"privatelink.postgres.database.azure.com",
"privatelink.mysql.database.azure.com",
"privatelink.mariadb.database.azure.com",
"privatelink.vaultcore.azure.net",
"privatelink.managedhsm.azure.net",
"privatelink.centralus.azmk8s.io",
"centralus.privatelink.centralus.azmk8s.io",
"privatelink.search.windows.net",
"privatelink.azurecr.io",
"centralus.privatelink.azurecr.io",
"privatelink.azconfig.io",
"privatelink.centralus.backup.windowsazure.com",
"privatelink.siterecovery.windowsazure.com",
"privatelink.servicebus.windows.net",
"privatelink.azure-devices.net",
"privatelink.servicebus.windows.net",
"privatelink.azure-devices-provisioning.net",
"privatelink.servicebus.windows.net",
"privatelink.eventgrid.azure.net",
"privatelink.azurewebsites.net",
"scm.privatelink.azurewebsites.net",
"privatelink.api.azureml.ms",
"privatelink.notebooks.azure.net",
"privatelink.service.signalr.net",
"privatelink.monitor.azure.com",
"privatelink.oms.opinsights.azure.com",
"privatelink.ods.opinsights.azure.com",
"privatelink.agentsvc.azure-automation.net",
"privatelink.blob.core.windows.net",
"privatelink.cognitiveservices.azure.com",
"privatelink.openai.azure.com",
"centralus.privatelink.afs.azure.net",
"privatelink.datafactory.azure.net",
"privatelink.adf.azure.com",
"privatelink.redis.cache.windows.net",
"privatelink.redisenterprise.cache.azure.net",
"privatelink.purview.azure.com",
"privatelink.purviewstudio.azure.com",
"privatelink.digitaltwins.azure.net",
"privatelink.azurehdinsight.net",
"privatelink.his.arc.azure.com",
"privatelink.guestconfiguration.azure.com",
"privatelink.kubernetesconfiguration.azure.com",
"privatelink.media.azure.net",
"privatelink.centralus.kusto.windows.net",
"privatelink.azurestaticapps.net",
"privatelink.centralus.azurestaticapps.net",
"privatelink.prod.migration.windowsazure.com",
"privatelink.azure-api.net",
"privatelink.analysis.windows.net",
"privatelink.pbidedicated.windows.net",
"privatelink.tip1.powerquery.microsoft.com",
"privatelink.directline.botframework.com",
"privatelink.token.botframework.com",
"privatelink.workspace.azurehealthcareapis.com",
"privatelink.fhir.azurehealthcareapis.com",
"privatelink.dicom.azurehealthcareapis.com",
"privatelink.azuredatabricks.net",
"privatelink-global.wvd.microsoft.com",
"privatelink.wvd.microsoft.com"

#
# Create zones from array
#
foreach ($Zone in $ZoneArray)
{
  New-AzPrivateDnsZone -Name $Zone -ResourceGroupName $AzDNSRG
}

#
# PDNS Link Hub
#
$vnethub = Get-AzVirtualNetwork -ResourceGroupName $AzVnetHubRG

foreach ($Zone in $ZoneArray)
{
  New-AzPrivateDnsVirtualNetworkLink `
          -ZoneName $Zone `
          -ResourceGroupName $AzDNSRG `
          -Name $AzVnetHubName `
          -VirtualNetworkId $vnethub.id
  }

#
# PDNS Link Prod
#
$vnetprod = Get-AzVirtualNetwork -ResourceGroupName $AzVnetProdRG

foreach ($Zone in $ZoneArray)
{
  New-AzPrivateDnsVirtualNetworkLink `
          -ZoneName $Zone `
          -ResourceGroupName $AzDNSRG `
          -Name $AzVnetProdName `
          -VirtualNetworkId $vnetprod.id
  }

#
# Get Something
#