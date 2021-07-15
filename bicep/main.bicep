param location string


var suffix = uniqueString(resourceGroup().id)

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
    subnetName: vnet.outputs.subnetName
    suffix: suffix
    vnetId: vnet.outputs.vnetId
  }
}