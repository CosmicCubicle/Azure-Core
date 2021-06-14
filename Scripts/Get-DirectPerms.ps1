
# Login to Azure and choose a tenant
$AzureCreds = Get-Credential
$Azure = Connect-AzAccount -Credential $AzureCreds
$Tenant = Get-AzTenant |Select-Object -Property ID, Name | Out-GridView -Title "Select Tenant/AzureAD instance" -PassThru
$Ad = Connect-AzureAD -TenantId $Tenant.Id -Credential $AzureCreds

#Create New CSV
$Outfile = "C:\temp\Permissions.csv"
$csvfile={} 

#Check For Assignments at Management Group Level
$Groups = Get-AzManagementGroup
foreach($Group in $Groups)
{
    $Group.DisplayName
    $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}

    Foreach($RBAC in $RBACs)
    {
        $csvfile.Scope = $Group.Id
        $csvfile.SignInName = $RBACs.SignInName
        $csvfile.RoleDefinitionName = $RBAC.RoleDefinitionName
        $csvfile.ObjectType = $RBAC.ObjectType
        $csvfile.ObjectId = $RBAC.ObjectId
        $csvfile | Export-Csv $Outfile -Append -NoTypeInformation
    }
}

$Subs = Get-AzSubscription
foreach($Sub in $Subs)
{
    Set-AzContext $sub
    $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}
    Foreach($RBAC in $RBACs)
    {
        $csvfile.Scope = "/subscriptions/$($Sub.id)"
        $csvfile.SignInName = $RBACs.SignInName
        $csvfile.RoleDefinitionName = $RBAC.RoleDefinitionName
        $csvfile.ObjectType = $RBAC.ObjectType
        $csvfile.ObjectId = $RBAC.ObjectId
        $csvfile | Export-Csv $Outfile -Append -NoTypeInformation
    }

    $RGs = Get-AzResourceGroup
    foreach($RG in $RGs)
    {
        $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}
        Foreach($RBAC in $RBACs)
        {
            $csvfile.Scope = $RG.ResourceId
            $csvfile.SignInName = $RBACs.SignInName
            $csvfile.RoleDefinitionName = $RBAC.RoleDefinitionName
            $csvfile.ObjectType = $RBAC.ObjectType
            $csvfile.ObjectId = $RBAC.ObjectId
            $csvfile | Export-Csv $Outfile -Append -NoTypeInformation
        }
        
        $Resources = Get-AzResource -ResourceGroupName $RG.ResourceGroupName
        foreach($Resource in $Resources)
        {
            $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}
            Foreach($RBAC in $RBACs)
            {
                $csvfile.Scope = $Resource.ResourceId
                $csvfile.SignInName = $RBACs.SignInName
                $csvfile.RoleDefinitionName = $RBAC.RoleDefinitionName
                $csvfile.ObjectType = $RBAC.ObjectType
                $csvfile.ObjectId = $RBAC.ObjectId
                $csvfile | Export-Csv $Outfile -Append -NoTypeInformation
            }   
        }

    }

}