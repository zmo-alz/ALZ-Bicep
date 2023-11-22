# Verify PowerShell Version and Install Az and ALZ Modules
$PSVersionTable.PSVersion
Install-Module -Name Az -Repository PSGallery -Force
Install-Module -Name ALZ -Repository PSGallery -Force
Import-Module Az
Import-Module ALZ

## Connect to Azure based on Tenant ID
$TenantID = "c2220b5a-0aaf-47b0-9a1a-4b52b0a58969"
Connect-AzAccount -tenant $TenantID

## Verify ALZ Requirements are met
Test-ALZRequirement -IaC "bicep"

## Create ALZ Accelerator
New-ALZEnvironment -o . -IaC "bicep" -cicd "github"

### Create a service principal for ALZ + GitHub

##get object Id of the current user (that is used above)
$user = Get-AzADUser -UserPrincipalName (Get-AzContext).Account

## Assign Owner role at Tenant root scope ("/") as a User Access Administrator to current user
New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

## (optional) Assign Owner role at Tenant root scope ("/") as a User Access Administrator to service principal (set $spndisplayname to your service principal displayname)

$spndisplayname = "zmo-alz-github"
New-AzADApplication -DisplayName $spndisplayname 
$clientId = (Get-AzADApplication -DisplayName $spndisplayname).AppId
New-AzADServicePrincipal -ApplicationId $clientId
$spn = (Get-AzADServicePrincipal -DisplayName $spndisplayname).id
New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $spn

## Federated Credentials for GitHub
$GHrepo='repo:octo-org/octo-repo:environment:Production'
$GHmanagedIdenity = 'GitHub-Actions-Test'
New-AzADAppFederatedCredential -ApplicationObjectId $clientId -Audience api://AzureADTokenExchange -Issuer 'https://token.actions.githubusercontent.com/' -Name $GHmanagedIdenity -Subject $GHrepo


GitHub Secret	Azure Active Directory Application
AZURE_CLIENT_ID	= $clientId = (Get-AzADApplication -DisplayName $spndisplayname).AppId
AZURE_TENANT_ID = $tenantId = (Get-AzContext).Subscription.TenantId	Directory (tenant) ID
AZURE_SUBSCRIPTION_ID = $subscriptionId = (Get-AzContext).Subscription.Id