param location string
param appInsightKey string
param appInsightCnxString string
param serverFarmId string

var webAppName = 'lipsum-api'

resource webapp 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName
  location: location
  properties: {  
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightCnxString
        }
      ]
      linuxFxVersion: 'NODE|14-lts'
      alwaysOn: true
    }
    serverFarmId: serverFarmId
    clientAffinityEnabled: false
  }
}
