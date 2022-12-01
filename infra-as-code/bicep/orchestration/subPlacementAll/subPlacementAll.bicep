targetScope = 'managementGroup'

metadata name = 'ALZ Bicep orchestration - Subscription Placement - ALL'
metadata description = 'Orchestration module that helps to define where all Subscriptions should be placed in the ALZ Management Group Hierarchy'

@sys.description('Prefix for the management group hierarchy.  This management group will be created as part of the deployment. Default: alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('An array of Subscription IDs to place in the Intermediate Root Management Group. Default: Empty Array')
param parIntRootMgSubs array = []

@sys.description('An array of Subscription IDs to place in the Platform Management Group. Default: Empty Array')
param parPlatformMgSubs array = []

@sys.description('An array of Subscription IDs to place in the (Platform) Management Management Group. Default: Empty Array')
param parPlatformManagementMgSubs array = []

@sys.description('An array of Subscription IDs to place in the (Platform) Connectivity Management Group. Default: Empty Array')
param parPlatformConnectivityMgSubs array = []

@sys.description('An array of Subscription IDs to place in the (Platform) Identity Management Group. Default: Empty Array')
param parPlatformIdentityMgSubs array = []

@sys.description('An array of Subscription IDs to place in the Landing Zones Management Group. Default: Empty Array')
param parLandingZonesMgSubs array = []

@sys.description('An array of Subscription IDs to place in the internal (Landing Zones) Management Group. Default: Empty Array')
param parLandingZonesinternalMgSubs array = []

@sys.description('An array of Subscription IDs to place in the native (Landing Zones) Management Group. Default: Empty Array')
param parLandingZonesnativeMgSubs array = []

@sys.description('An array of Subscription IDs to place in the Confidential internal (Landing Zones) Management Group. Default: Empty Array')
param parLandingZonesConfidentialinternalMgSubs array = []

@sys.description('An array of Subscription IDs to place in the Confidential native (Landing Zones) Management Group. Default: Empty Array')
param parLandingZonesConfidentialnativeMgSubs array = []

@sys.description('Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group describing the Subscription IDs which each of them contain. Default: Empty Object')
param parLandingZoneMgChildrenSubs object = {}

@sys.description('An array of Subscription IDs to place in the Decommissioned Management Group. Default: Empty Array')
param parDecommissionedMgSubs array = []

@sys.description('An array of Subscription IDs to place in the Sandbox Management Group. Default: Empty Array')
param parSandboxMgSubs array = []

@sys.description('Set Parameter to true to Opt-out of deployment telemetry. Default: false')
param parTelemetryOptOut bool = true

var varMgIds = {
  intRoot: parTopLevelManagementGroupPrefix
  platform: '${parTopLevelManagementGroupPrefix}-platform'
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones'
  landingZonesinternal: '${parTopLevelManagementGroupPrefix}-landingzones-internal'
  landingZonesnative: '${parTopLevelManagementGroupPrefix}-landingzones-native'
  landingZonesConfidentialinternal: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-internal'
  landingZonesConfidentialnative: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-native'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox'
}

var varDeploymentNames = {
  modIntRootMgSubPlacement: take('modIntRootMgSubPlacement-${uniqueString(varMgIds.intRoot, string(length(parIntRootMgSubs)), deployment().name)}', 64)
  modPlatformMgSubPlacement: take('modPlatformMgSubPlacement-${uniqueString(varMgIds.platform, string(length(parPlatformMgSubs)), deployment().name)}', 64)
  modPlatformManagementMgSubPlacement: take('modPlatformManagementMgSubPlacement-${uniqueString(varMgIds.platformManagement, string(length(parPlatformManagementMgSubs)), deployment().name)}', 64)
  modPlatformConnectivityMgSubPlacement: take('modPlatformConnectivityMgSubPlacement-${uniqueString(varMgIds.platformConnectivity, string(length(parPlatformConnectivityMgSubs)), deployment().name)}', 64)
  modPlatformIdentityMgSubPlacement: take('modPlatformIdentityMgSubPlacement-${uniqueString(varMgIds.platformIdentity, string(length(parPlatformIdentityMgSubs)), deployment().name)}', 64)
  modLandingZonesMgSubPlacement: take('modLandingZonesMgSubPlacement-${uniqueString(varMgIds.landingZones, string(length(parLandingZonesMgSubs)), deployment().name)}', 64)
  modLandingZonesinternalMgSubPlacement: take('modLandingZonesinternalMgSubPlacement-${uniqueString(varMgIds.landingZonesinternal, string(length(parLandingZonesinternalMgSubs)), deployment().name)}', 64)
  modLandingZonesnativeMgSubPlacement: take('modLandingZonesnativeMgSubPlacement-${uniqueString(varMgIds.landingZonesnative, string(length(parLandingZonesnativeMgSubs)), deployment().name)}', 64)
  modLandingZonesConfidentialinternalMgSubPlacement: take('modLandingZonesConfidentialinternalMgSubPlacement-${uniqueString(varMgIds.landingZonesConfidentialinternal, string(length(parLandingZonesConfidentialinternalMgSubs)), deployment().name)}', 64)
  modLandingZonesConfidentialnativeMgSubPlacement: take('modLandingZonesConfidentialnativeMgSubPlacement-${uniqueString(varMgIds.landingZonesConfidentialnative, string(length(parLandingZonesConfidentialnativeMgSubs)), deployment().name)}', 64)
  modDecommissionedMgSubPlacement: take('modDecommissionedMgSubPlacement-${uniqueString(varMgIds.decommissioned, string(length(parDecommissionedMgSubs)), deployment().name)}', 64)
  modSandboxMgSubPlacement: take('modSandboxMgSubPlacement-${uniqueString(varMgIds.sandbox, string(length(parSandboxMgSubs)), deployment().name)}', 64)
}

// Customer Usage Attribution Id
var varCuaid = 'bb800623-86ff-4ab4-8901-93c2b70967ae'

module modIntRootMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parIntRootMgSubs)) {
  name: varDeploymentNames.modIntRootMgSubPlacement
  scope: managementGroup(varMgIds.intRoot)
  params: {
    parTargetManagementGroupId: varMgIds.intRoot
    parSubscriptionIds: parIntRootMgSubs
  }
}

// Platform Management Groups
module modPlatformMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parPlatformMgSubs)) {
  name: varDeploymentNames.modPlatformMgSubPlacement
  scope: managementGroup(varMgIds.platform)
  params: {
    parTargetManagementGroupId: varMgIds.platform
    parSubscriptionIds: parPlatformMgSubs
  }
}

module modPlatformManagementMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parPlatformManagementMgSubs)) {
  name: varDeploymentNames.modPlatformManagementMgSubPlacement
  scope: managementGroup(varMgIds.platformManagement)
  params: {
    parTargetManagementGroupId: varMgIds.platformManagement
    parSubscriptionIds: parPlatformManagementMgSubs
  }
}

module modplatformConnectivityMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parPlatformConnectivityMgSubs)) {
  name: varDeploymentNames.modPlatformConnectivityMgSubPlacement
  scope: managementGroup(varMgIds.platformConnectivity)
  params: {
    parTargetManagementGroupId: varMgIds.platformConnectivity
    parSubscriptionIds: parPlatformConnectivityMgSubs
  }
}

module modplatformIdentityMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parPlatformIdentityMgSubs)) {
  name: varDeploymentNames.modPlatformIdentityMgSubPlacement
  scope: managementGroup(varMgIds.platformIdentity)
  params: {
    parTargetManagementGroupId: varMgIds.platformIdentity
    parSubscriptionIds: parPlatformIdentityMgSubs
  }
}

// Landing Zone Management Groups
module modLandingZonesMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parLandingZonesMgSubs)) {
  name: varDeploymentNames.modLandingZonesMgSubPlacement
  scope: managementGroup(varMgIds.landingZones)
  params: {
    parTargetManagementGroupId: varMgIds.landingZones
    parSubscriptionIds: parLandingZonesMgSubs
  }
}

module modLandingZonesinternalMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parLandingZonesinternalMgSubs)) {
  name: varDeploymentNames.modLandingZonesinternalMgSubPlacement
  scope: managementGroup(varMgIds.landingZonesinternal)
  params: {
    parTargetManagementGroupId: varMgIds.landingZonesinternal
    parSubscriptionIds: parLandingZonesinternalMgSubs
  }
}

module modLandingZonesnativeMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parLandingZonesnativeMgSubs)) {
  name: varDeploymentNames.modLandingZonesnativeMgSubPlacement
  scope: managementGroup(varMgIds.landingZonesnative)
  params: {
    parTargetManagementGroupId: varMgIds.landingZonesnative
    parSubscriptionIds: parLandingZonesnativeMgSubs
  }
}

// Confidential Landing Zone Management Groups
module modLandingZonesConfidentialinternalMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parLandingZonesConfidentialinternalMgSubs)) {
  name: varDeploymentNames.modLandingZonesConfidentialinternalMgSubPlacement
  scope: managementGroup(varMgIds.landingZonesConfidentialinternal)
  params: {
    parTargetManagementGroupId: varMgIds.landingZonesConfidentialinternal
    parSubscriptionIds: parLandingZonesConfidentialinternalMgSubs
  }
}

module modLandingZonesConfidentialnativeMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parLandingZonesConfidentialnativeMgSubs)) {
  name: varDeploymentNames.modLandingZonesConfidentialnativeMgSubPlacement
  scope: managementGroup(varMgIds.landingZonesConfidentialnative)
  params: {
    parTargetManagementGroupId: varMgIds.landingZonesConfidentialnative
    parSubscriptionIds: parLandingZonesConfidentialnativeMgSubs
  }
}

// Custom Children Landing Zone Management Groups
module modLandingZonesMgChildrenSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = [for mg in items(parLandingZoneMgChildrenSubs): if (!empty(parLandingZoneMgChildrenSubs)) {
  name: take('modLandingZonesMgChildrenSubPlacement-${uniqueString(mg.key, string(length(mg.value.subscriptions)), deployment().name)}', 64)
  scope: managementGroup('${parTopLevelManagementGroupPrefix}-landingzones-${mg.key}')
  params: {
    parTargetManagementGroupId: '${parTopLevelManagementGroupPrefix}-landingzones-${mg.key}'
    parSubscriptionIds: mg.value.subscriptions
  }
}]

// Decommissioned Management Group
module modDecommissionedMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parDecommissionedMgSubs)) {
  name: varDeploymentNames.modDecommissionedMgSubPlacement
  scope: managementGroup(varMgIds.decommissioned)
  params: {
    parTargetManagementGroupId: varMgIds.decommissioned
    parSubscriptionIds: parDecommissionedMgSubs
  }
}

// Sandbox Management Group
module modSandboxMgSubPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parSandboxMgSubs)) {
  name: varDeploymentNames.modSandboxMgSubPlacement
  scope: managementGroup(varMgIds.sandbox)
  params: {
    parTargetManagementGroupId: varMgIds.sandbox
    parSubscriptionIds: parSandboxMgSubs
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
