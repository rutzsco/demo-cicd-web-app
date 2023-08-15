@description('Web app name.')
@minLength(2)
param webAppName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Describes plan\'s pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param sku string = 'B1'
param currentStack string = 'dotnet'
param netFrameworkVersion string = 'v7.0'

var appServicePlanName = 'AppServicePlan-${webAppName}'

resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      alwaysOn: true
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      metadata:[
        {
          name: 'CURRENT_STACK'
          value: currentStack
        }
      ]
      netFrameworkVersion: netFrameworkVersion
    }
    serverFarmId: asp.id
    httpsOnly: true
    clientAffinityEnabled: false
  }
}
