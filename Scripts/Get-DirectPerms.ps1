
# Login to Azure and choose a tenant
$AzureCreds = Get-Credential
$Azure = Connect-AzAccount -Credential $AzureCreds
$Tenant = Get-AzTenant |Select-Object -Property ID, Name | Out-GridView -Title "Select Tenant/AzureAD instance" -PassThru
$Ad = Connect-AzureAD -TenantId $Tenant.Id -Credential $AzureCreds

#Create New CSV
<<<<<<< Updated upstream
$Outfile = "C:\temp\Permissions.csv"
$csvfile={} 
=======
$Outfile = "C:\temp\Permissions1.csv"
$csvfile=@{} 
>>>>>>> Stashed changes

#Check For Assignments at Management Group Level
$Groups = Get-AzManagementGroup
foreach($Group in $Groups)
{
    $Group.DisplayName
    $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}

    Foreach($RBAC in $RBACs)
    {
        $csvfile |Add-Member -MemberType NoteProperty -Name 'Scope' -Value $Group.Id
        $csvfile |Add-Member -MemberType NoteProperty -Name 'SignInName' -Value $RBACs.SignInName
        $csvfile |Add-Member -MemberType NoteProperty -Name 'RoleDefinitionName' -Value $RBAC.RoleDefinitionName
        $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $RBAC.ObjectType
        $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectId' -Value $RBAC.ObjectId
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
        $csvfile = Import-Csv -Path $Outfile
        foreach($csvfile in $csv)
        {
            $csvfile |Add-Member -MemberType NoteProperty -Name 'Scope' -Value "/subscriptions/$($Sub.id)"
            $csvfile |Add-Member -MemberType NoteProperty -Name 'SignInName' -Value $RBACs.SignInName
            $csvfile |Add-Member -MemberType NoteProperty -Name 'RoleDefinitionName' -Value $RBAC.RoleDefinitionName
            $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $RBAC.ObjectType
            $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectId' -Value $RBAC.ObjectId
            $csv | Export-Csv $Outfile -Append -NoTypeInformation
        }
    }

    $RGs = Get-AzResourceGroup
    foreach($RG in $RGs)
    {
        $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}
        Foreach($RBAC in $RBACs)
        {
            $csvfile |Add-Member -MemberType NoteProperty -Name 'Scope' -Value $RG.ResourceId
            $csvfile |Add-Member -MemberType NoteProperty -Name 'SignInName' -Value $RBACs.SignInName
            $csvfile |Add-Member -MemberType NoteProperty -Name 'RoleDefinitionName' -Value $RBAC.RoleDefinitionName
            $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $RBAC.ObjectType
            $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectId' -Value $RBAC.ObjectId    
            $csvfile | Export-Csv $Outfile -Append -NoTypeInformation
        }
        
        $Resources = Get-AzResource -ResourceGroupName $RG.ResourceGroupName
        foreach($Resource in $Resources)
        {
            $RBACs = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/"}
            Foreach($RBAC in $RBACs)
            {
                $csvfile |Add-Member -MemberType NoteProperty -Name 'Scope' -Value $Resource.ResourceId
                $csvfile |Add-Member -MemberType NoteProperty -Name 'SignInName' -Value $RBACs.SignInName
                $csvfile |Add-Member -MemberType NoteProperty -Name 'RoleDefinitionName' -Value $RBAC.RoleDefinitionName
                $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $RBAC.ObjectType
                $csvfile |Add-Member -MemberType NoteProperty -Name 'ObjectId' -Value $RBAC.ObjectId        
                $csvfile | Export-Csv $Outfile -Append -NoTypeInformation
            }   
        }

    }

}