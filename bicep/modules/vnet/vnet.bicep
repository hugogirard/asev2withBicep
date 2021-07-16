param location string
param suffix string

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: 'nsg-ase'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Inbound-management'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 100
          sourcePortRange: '*'
          destinationPortRange: '454-455'
          sourceAddressPrefix: 'AppServiceManagement'
          destinationAddressPrefix: '*'
        }
      }      
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'vnet-${suffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ase-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

output aseSubnetId string = vnet.properties.subnets[0].id
output vnetId string = vnet.id
//output subnetName string = subnet.name
