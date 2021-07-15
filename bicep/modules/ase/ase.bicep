param location string
param suffix string
param vnetId string
param subnetName string

var aseName = 'ase-${suffix}'
var appServicePlanName = 'app-plan-${suffix}'
var internalLoadBalancingMode = 'Web,Publishing'
var workerPool = '1'

resource hostingEnvironment 'Microsoft.Web/hostingEnvironments@2020-06-01' = {
  name: aseName
  location: location
  kind: 'ASEV2'
  properties: {
    name: aseName
    location: location
    ipsslAddressCount: 0
    internalLoadBalancingMode: internalLoadBalancingMode
    virtualNetwork: {
      id: vnetId
      subnet: subnetName
    }
    workerPools: []
    osPreference: 'linux'
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: ''
  location: 'global'
  dependsOn: [
    hostingEnvironment
  ]
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: '${privateDnsZone.name}/vnetLink'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: true
  }
}

resource aRecordOne 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${privateDnsZone.name}/*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: reference('${hostingEnvironment.id}/capacities/virtualip','2019-08-01').internalIpAddress
      }
    ]
  }
}

resource aRecordTwo 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${privateDnsZone.name}/*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: reference('${hostingEnvironment.id}/capacities/virtualip','2019-08-01').internalIpAddress
      }
    ]
  }
}


resource aRecordThree 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${privateDnsZone.name}/@'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: reference('${hostingEnvironment.id}/capacities/virtualip','2019-08-01').internalIpAddress
      }
    ]
  }
}


// resource serverFarm 'Microsoft.Web/serverfarms@2020-06-01' = {
//   name: appServicePlanName
//   location: location
//   properties: {
//     hostingEnvironmentProfile: {
//       id: hostingEnvironment.id
//     }
//   }
//   sku: {
//     name: 'I${workerPool}'
//     tier: 'Isolated'
//     size: 'I${workerPool}'
//     family: 'I'
//     capacity: 1
//   }
// }

// resource website 'Microsoft.Web/sites@2020-06-01' = {
//   name: websiteName
//   location: location
//   properties: {
//     serverFarmId: serverFarm.id
//     hostingEnvironmentProfile: {
//       id: hostingEnvironment.id
//     }
//   }
// }
