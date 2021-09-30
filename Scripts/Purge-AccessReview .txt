# Login to Azure
Connect-AzAccount
Connect-AzureAD

#Install Graph Identity Governance Module
Install-Module -Name Microsoft.Graph.Authentication
Install-Module -Name Microsoft.Graph.Identity.Governance
Import-Module Microsoft.Graph.Identity.Governance
Import-Module Microsoft.Graph.Authentication


#Login to Graph
Connect-MgGraph -Scopes "AccessReview.ReadWrite.All"
Select-MgProfile "beta"

#Get Access Reviews
$Reviews = @()
$10Reviews = Invoke-MgGraphRequest -Uri 'beta/identityGovernance/accessReviews/definitions?top=10' -OutputType PSObject
$Reviews += $10Reviews.value |Select-Object DisplayName, Id
$NextLink = $10Reviews.'@odata.nextLink'
while(!([string]::IsNullOrEmpty($NextLink)))
{
    $FullReview = Invoke-MgGraphRequest -uri $NextLink -outputtype PsObject
    $NextLink = $FullReview.'@odata.nextLink'
    $Reviews += $FullReview.value |Select-Object DisplayName, Id
}
$Reviews

foreach ($Review in $Reviews) {
    Invoke-MgGraphRequest -Method Delete -Uri "https://graph.microsoft.com/beta/identityGovernance/accessReviews/definitions/$($Review.id)"
}

#List Access Reviews
$NewReviews = (Invoke-MgGraphRequest -Uri "beta/identityGovernance/accessReviews/definitions" -OutputType PSObject).value
$NewReviews | FT displayName,id

