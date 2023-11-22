$PSVersionTable.PSVersion
Install-Module -Name Az -Repository PSGallery -Force
Install-Module -Name Az.ResourceGraph
Import-Module Az
$TenantID = "c2220b5a-0aaf-47b0-9a1a-4b52b0a58969"
$intermediateRootGroupID = "zmoalz"
$eslzAADSPNName = "zmoalz"

Connect-AzAccount -tenant $TenantID
 Set-AzContext -Tenant $TenantID
cd .\Nuke-Refresh-ALZ-Deployment\
.\Wipe-ALZ-Demo-Tenant.ps1 -tenantRootGroupID $TenantID -intermediateRootGroupID $intermediateRootGroupID -resetMdfcTierOnSubs:$true