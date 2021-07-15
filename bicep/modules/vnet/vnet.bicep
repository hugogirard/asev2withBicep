param location string
param suffix string

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'vnet-${suffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: '${vnet.name}/ase-subnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

output vnetId string = vnet.id
output subnetName string = subnet.name
