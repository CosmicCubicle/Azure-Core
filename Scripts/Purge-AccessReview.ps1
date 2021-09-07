# Login to Azure and choose a tenant
$AzureCreds = Get-Credential
$Azure = Connect-AzAccount -Credential $AzureCreds
$Tenant = Get-AzTenant |Select-Object -Property ID, Name | Out-GridView -Title "Select Tenant/AzureAD instance" -PassThru
$Ad = Connect-AzureAD -TenantId $Tenant.Id -Credential $AzureCreds

#Install Graph Identity Governance Module
Install-Module -Name Microsoft.Graph.Authentication
Install-Module -Name Microsoft.Graph.Identity.Governance
Import-Module Microsoft.Graph.Identity.Governance

#Login to Graph
Connect-MgGraph -Scopes "AccessReview.ReadWrite.All"
Select-MgProfile "beta"

#Get Access Reviews
$Reviews = (Invoke-MgGraphRequest -Uri "beta/identityGovernance/accessReviews/definitions" -OutputType PSObject).value
$Reviews | FT displayName,id
foreach ($Review in $Reviews) {
    Invoke-MgGraphRequest -Method Delete -Uri "https://graph.microsoft.com/beta/identityGovernance/accessReviews/definitions/$($Review.id)"
}


#List Access Reviews

#Purge Review

#List Access Reviews