$Creds = Get-Credential
Connect-AzAccount -Credential $Creds
$Context = Get-AzSubscription | Out-GridView -PassThru | Set-AzContext
Get-AzContext
az login -u $Creds.UserName -p $Creds.Password
az account set --subscription $Context.Subscription