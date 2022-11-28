@allowed([
  '1'
  '2'
  '3'
])
param deploymentFarm string = '1'
param siteId string = '002'

@allowed([
  'nprd'
  'stage'
  'prod'
])
param environment string = 'nprd'

var appService_var = '${environment}-ctcms-ct${siteId}-app'
var webServerfarm = '${environment}-ctcms-df${deploymentFarm}-asp'

var resourceGroup2 = 'nprd-ctcms-df1-net-rg'
var virtualNetwork1 = 'nprd-ctcms-df1-vnet'
var subnet1 = 'df1-asp-sn'

resource appService1 'Microsoft.Web/sites@2020-12-01' = {
  name: appService_var
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'app,linux,container'
  location: resourceGroup().location
  properties: {
    enabled: true
    httpsOnly: true
    redundancyMode: 'None'
    reserved: true
    serverFarmId: resourceId('Microsoft.Web/serverfarms', webServerfarm)
    siteConfig: {
      alwaysOn: true
      appSettings: []
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
      connectionStrings: []
      defaultDocuments: []
      ftpsState: 'FtpsOnly'
      handlerMappings: []
      ipSecurityRestrictions: []
      loadBalancing: 'LeastResponseTime'
      minTlsVersion: '1.2'
      scmIpSecurityRestrictions: []
    }
    virtualNetworkSubnetId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/nprd-ctcms-net-rg/providers/Microsoft.Network/virtualNetworks/nprd-ctcms-df${deploymentFarm}-vnet/subnets/df${deploymentFarm}-asp-sn'
  }
}

resource appService1_appServiceConfigRegionalVirtualNetworkIntegration1 'Microsoft.Web/sites/config@2018-11-01' = {
  parent: appService1
  name: 'appsettings'
  properties: {
    subnetResourceId: resourceId(resourceGroup2, 'Microsoft.Network/virtualNetworks/subnets', virtualNetwork1, subnet1)
  }
}
