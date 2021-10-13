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
      {
        name: 'ASE-internal-inbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: '*'
          priority: 101
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Inbound-load-balancer'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority: 102
          sourcePortRange: '*'
          destinationPortRange: '16001'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Outbound-web'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          priority: 100
          sourcePortRange: '*'
          destinationPortRanges: [
            '80'
            '443'
          ]
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Time-NTP'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Udp'
          priority: 101
          sourcePortRange: '*'
          destinationPortRange: '123'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Outbound-DB'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          priority: 102
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Sql'
        }
      }
      {
        name: 'Outbound-monitor'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          priority: 103
          sourcePortRange: '*'
          destinationPortRange: '12000'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }      
      {
        name: 'Outbound-DNS'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Udp'
          priority: 104
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }        
      {
        name: 'ASE-internal-Outbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: '*'
          priority: 105
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'deny-internet'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          protocol: '*'
          priority: 106
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }                                                
    ]
  }
}

resource nsgJumpbox 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: 'nsg-jumpbox'
  location: location
  properties: {
    securityRules: [
      
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
          serviceEndpoints: [
            {
              service: 'Microsoft.Sql'
            }
            {
              service: 'Microsoft.EventHub'
            }
            {
              service: 'Microsoft.Storage'
            }                        
          ]
        }
      }
    ]
  }
}

output aseSubnetId string = vnet.properties.subnets[0].id
output vnetId string = vnet.id
//output subnetName string = subnet.name
