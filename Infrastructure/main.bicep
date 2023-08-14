param webAppName string = 'myorgname'
param location string = resourceGroup().location

module appServiceModule 'app-service.bicep' = {
  name: 'appServiceDeplpyment'
  params: {
    webAppName: webAppName
    location: location
  }
}
