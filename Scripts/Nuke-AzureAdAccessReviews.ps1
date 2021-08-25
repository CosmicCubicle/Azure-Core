# Login to Azure and choose a tenant
$AzureCreds = Get-Credential
$Azure = Connect-AzAccount -Credential $AzureCreds
$Tenant = Get-AzTenant |Select-Object -Property ID, Name | Out-GridView -Title "Select Tenant/AzureAD instance" -PassThru
$Ad = Connect-AzureAD -TenantId $Tenant.Id -Credential $AzureCreds
