param environmentName string

@description('Client IP for firewall rules')
param IP string

@description('Password for the web Virtual Machine Admin User')
param pgAdminPass string = newGuid()


@description('Location for all resources.')
param location string = resourceGroup().location

@description('Abbreviated Names of the Azure Services that can be used as part of naming resource convention')
var abbrs = loadJsonContent('./abbreviations.json')

@description('Id of the user or app to assign application roles')
param principalId string = ''

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var mainserver = 'main-${abbrs.dBforPostgreSQLServers}${resourceToken}'
var openai = 'oai-${abbrs.cognitiveServicesAccounts}${resourceToken}'
var text = 'lang-${abbrs.cognitiveServicesAccounts}${resourceToken}'
var translate = 'trslt-${abbrs.cognitiveServicesAccounts}${resourceToken}'
var replicaserver = 'replica-${abbrs.dBforPostgreSQLServers}${resourceToken}'
var keyvaultname = '${abbrs.keyVaultVaults}${resourceToken}'


resource keyvault 'Microsoft.KeyVault/vaults@2024-12-01-preview' = {
  name: keyvaultname
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'Standard'
    }
    tenantId: tenant().tenantId
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    accessPolicies: [
      {
        tenantId: tenant().tenantId
        objectId: principalId
        permissions: {
          certificates: []
          keys: []
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
          ]
        }
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}

resource pgAdminKey 'Microsoft.KeyVault/vaults/secrets@2024-12-01-preview' = {
  parent: keyvault
  name: 'pgAdmin'
  location: location
  properties: {
    value: pgAdminPass
    attributes: {
      enabled: true      
    }
  }
}

resource translatorService 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: translate
  location: location
  kind: 'TextTranslation'
  sku: {
    name: 'S1'
  }
  properties: {
    customSubDomainName: translate
    publicNetworkAccess: 'Enabled'
    restore: false
  } 
}

resource text_resource 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: text
  location: location
  sku: {
    name: 'S'
  }
  kind: 'TextAnalytics'
  properties: {
    apiProperties: {}
    customSubDomainName: text
    publicNetworkAccess: 'Enabled'
  }
}

resource openai_resource 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: openai
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {}
    customSubDomainName: openai
    publicNetworkAccess: 'Enabled'
  }
}

resource mainserver_resource 'Microsoft.DBforPostgreSQL/flexibleServers@2024-11-01-preview' = {
  name: mainserver
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    replica: {
      role: 'Primary'
    }
    storage: {
      iops: 500
      tier: 'P10'
      storageSizeGB: 32
      autoGrow: 'Disabled'
    }
    network: {
      publicNetworkAccess: 'Enabled'
    }
    dataEncryption: {
      type: 'SystemManaged'
    }
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    version: '16'
    administratorLogin: 'pgAdmin'
    administratorLoginPassword: pgAdminPass
    availabilityZone: '1'
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    replicationRole: 'Primary'
  }
}

resource replicaserver_resource 'Microsoft.DBforPostgreSQL/flexibleServers@2024-11-01-preview' = {
  name: replicaserver
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    replica: {
      role: 'Primary'
    }
    storage: {
      iops: 120
      tier: 'P4'
      storageSizeGB: 32
      autoGrow: 'Disabled'
    }
    network: {
      publicNetworkAccess: 'Enabled'
    }
    dataEncryption: {
      type: 'SystemManaged'
    }
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    version: '16'
    administratorLogin: 'pgAdmin'
    administratorLoginPassword: pgAdminPass
    availabilityZone: '2'
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    replicationRole: 'Primary'
  }
}

resource openai_embedding 'Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview' = {
  parent: openai_resource
  name: 'embedding'
  sku: {
    name: 'Standard'
    capacity: 30
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '2'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 30
  }
}

resource AlloMyIPm 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2024-11-01-preview' = {
  parent: mainserver_resource
  name: 'AlloMyIP'
  properties: {
    startIpAddress: IP
    endIpAddress: IP  }
}

resource AlloMyIPr 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2024-11-01-preview' = {
  parent: replicaserver_resource
  name: 'AlloMyIP'
  properties: {
    startIpAddress: IP
    endIpAddress: IP  }
}

resource allowlistExtensions 'Microsoft.DBforPostgreSQL/flexibleServers/configurations@2023-03-01-preview' = {
  name: 'azure.extensions'
  parent: mainserver_resource
  properties: {
    source: 'user-override'
    value: 'azure_ai,vector'
  }
}

output PWD string = pgAdminPass
output KEYVAULT_ID string = keyvault.id
output PGHOST string = '${mainserver_resource.name}.postgres.database.azure.com'
