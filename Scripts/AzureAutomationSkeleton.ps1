
$connectionName = "AzureRunAsConnection"
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName 

    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

Get-AzContext

$RG = New-AzResourceGroup `
            -Name "CoreNetwork1" `
            -Location EastUS
            
$Vnet = New-AzVirtualNetwork `
            -Location $Rg.Location `
            -Name "Vnet-$($Rg.Location)" `
            -ResourceGroupName $Rg.ResourceGroupName `
            -AddressPrefix 10.34.0.0/24

$Plan = New-AzAppServicePlan `
            -ResourceGroupName $rg.ResourceGroupName `
            -Name "Plan12" `
            -Location $rg.Location `
            -Tier "Basic" `
            -NumberofWorkers 2 `
            -WorkerSize "Small"

$WebApp = New-AzWebApp `
            -Name "AppJeradClasssdasda" `
            -Location $rg.Location `
            -AppServicePlan $Plan.Name `
            -Verbose