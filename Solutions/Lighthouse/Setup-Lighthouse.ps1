#Login to Azure
Connect-AzAccount
$SubManaged = 'fc9ba59d-d9fb-4675-a494-73bd70b339c3'
$SubManager = 'f9a7cb32-f279-4757-b7d7-5989d2a8ad53'

#CreateGroups
New-AzADGroup -DisplayName "Lighthouse_Reader" -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_Contributor"  -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_NetworkContributor"  -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_VmContributor"  -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_DatabaseContributor"  -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_KeyVaultAdministrator"  -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_Owner"  -MailNickname "Lighthouse_Reader"
New-AzADGroup -DisplayName "Lighthouse_Automation"  -MailNickname "Lighthouse_Reader"

$Roles = Get-AzRoleDefinition | FT Name, ID
$Principals = Get-AzADGroup -DisplayNameStartsWith "Light" | FT DisplayName, ID
$Roles
$Principals

Connect-AzAccount -TenantId $SubManaged
Set-AzContext -Tenant $SubManaged

New-AzSubscriptionDeployment -Name 'LighthousePilot' `
                 -Location eastus2 `
                 -TemplateFile .\Solutions\Lighthouse\Lighthouse.json `
                 -TemplateParameterFile .\Solutions\Lighthouse\Lighthouse.parameters.json `
                 -managedByTenantId $SubManager `
                 -Verbose

# Log in first with Connect-AzAccount if you're not using Cloud Shell
Connect-AzAccount -TenantId $SubManager
Get-AzContext
Get-AzSubscription

# Confirm successful onboarding for Azure Lighthouse

Get-AzManagedServicesDefinition 
Get-AzManagedServicesAssignment

Connect-AzureAD
Revoke-AzureADUserAllRefreshToken -ObjectId "eed74f2c-c1d5-4e58-99ae-b9a5e0915f9c"