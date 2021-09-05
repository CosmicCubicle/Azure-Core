#Install Modules
Install-Module Az
Install-Module AzureAD
Install-Module Microsoft.Graph -Scope AllUsers
Install-module MsGraph
Install-module PSMsGraph -AllowClobber

# Login to Azure and choose a tenant
$AzureCreds = Get-Credential
$Azure = Connect-AzAccount -Credential $AzureCreds
$Tenant = Get-AzTenant |Select-Object -Property ID, Name | Out-GridView -Title "Select Tenant/AzureAD instance" -PassThru
$Ad = Connect-AzureAD -TenantId $Tenant.Id -Credential $AzureCreds
Get-GraphOauthAccessToken

Select-MgProfile -Name "beta"
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","AccessReview.ReadWrite.All"
$AccessReviews = "https://graph.microsoft.com/v1.0/identityGovernance/accessReviews/definitions"
$Params = @{
    'Uri' = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    'Method' = 'Post'
    'Body' = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}
$Header = @{
    Authorization = "$($Request.token_type) $($Request.access_token)"
}
$AccessReviewsRequest = Invoke-RestMethod -Uri $AccessReviews