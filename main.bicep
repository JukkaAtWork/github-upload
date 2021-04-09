targetScope = 'resourceGroup'

param location string = resourceGroup().location
param namePrefix string = 'stg'
var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
param globalRedundancy bool = true // defaults to true, but can be overridden

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku:{
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS' // if true --> GRS, else --> LRS
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg.name}/default/logs'
}

output storageID string = stg.id
output computedStorageName string = stg.name
output blobEndpoint string = stg.properties.primaryEndpoints.blob