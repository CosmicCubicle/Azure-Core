# Login to Azure and choose a tenant
#$AzureCreds = Get-Credential
$Azure = Connect-AzAccount # -Credential $AzureCreds
$Tenant = Get-AzTenant |Select-Object -Property ID, Name | Out-GridView -Title "Select Tenant/AzureAD instance" -PassThru
$Sub = Get-AzSubscription | Out-GridView -Title "Select Subscription" -PassThru | Set-AzContext
$Ad = Connect-AzureAD -TenantId $Tenant.Id # -Credential $AzureCreds

$Containers = Get-AzContainerRegistry
$Containers[0].NetworkRuleSet | FL
$Containers[1]