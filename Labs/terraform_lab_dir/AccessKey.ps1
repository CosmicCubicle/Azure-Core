$ResourceGroup = "TerraformDemo"
$Vault = Get-AzKeyVault -ResourceGroupName $ResourceGroup
$env:ARM_ACCESS_KEY= $(az keyvault secret show --name terraform --vault-name $Vault.VaultName --query value -o tsv)