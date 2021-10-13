param location string


var suffix = uniqueString(resourceGroup().id)

module logging 'modules/monitoring/monitoring.bicep' = {
  name: 'logging'
  params: {
    location: location
    suffix: suffix
  }
}

module vnet './modules/vnet/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    suffix: suffix
  }
}

module ase './modules/ase/ase.bicep' = {
  name: 'ase'
  params: {
    location: location
    suffix: suffix
    subnetId: vnet.outputs.aseSubnetId
    vnetId: vnet.outputs.vnetId
  }
}
