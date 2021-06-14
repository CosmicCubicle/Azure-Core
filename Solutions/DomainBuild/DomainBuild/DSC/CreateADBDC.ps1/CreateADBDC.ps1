configuration CreateADBDC 
{ 
   param 
    ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,

        [Parameter(Mandatory)]
        [String]$DnsServer,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    ) 
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory, xNetworking, xPendingReboot, xComputerManagement, xStorage
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
	$Interface = Get-NetAdapter|Where Name -Like "Ethernet*"|Select-Object -First 1
    $InterfaceAlias = $($Interface.Name)


    Node localhost
    {
        LocalConfigurationManager            
        {            
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true            
        } 
        
        
        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services"
            DependsOn = "[Script]MoveAzureTempDrive"
        } 

        Script DisablePageFile
        {
        
            GetScript  = { @{ Result = "" } }
            TestScript = { 
               $pf=gwmi win32_pagefilesetting
               #There's no page file so okay to enable on the new drive
               if ($pf -eq $null)
               {
                    return $true
               }
               #Page file is still on the D drive
               if ($pf.Name.ToLower().Contains('d:'))
               {
                    return $false
               }

               else
               {
                    return $true
               }
            
            }
            SetScript  = {
                #Change temp drive and Page file Location 
                gwmi win32_pagefilesetting
                $pf=gwmi win32_pagefilesetting
                $pf.Delete()
                Restart-Computer -Force
            }
           
        }


        Script MoveAzureTempDrive
        {
            GetScript  = { @{ Result = "" } }
            TestScript = { 
               $pf=gwmi win32_pagefilesetting
               #There's no page file so okay to enable on the new drive
               if ($pf -eq $null)
               {
                    return $false
               }
               else
               {
                    return $true
               }
            
            }
            SetScript = {
                $TempDriveLetter = 'F'
                Get-Partition -DiskNumber 1 -PartitionNumber 1 | Set-Partition -NewDriveLetter $TempDriveLetter
                $TempDriveLetter = $TempDriveLetter + ":"
                $drive = Get-WmiObject -Class win32_volume -Filter “DriveLetter = '$TempDriveLetter'”
                Out-File -FilePath c:\packages\driveinfo.txt -InputObject $drive
                    
                #re-enable page file on new Drive
                $drive = Get-WmiObject -Class win32_volume -Filter “DriveLetter = '$TempDriveLetter'”
                Set-WMIInstance -Class Win32_PageFileSetting -Arguments @{ Name = "$TempDriveLetter\pagefile.sys"; MaximumSize = 0; }
                Restart-Computer -Force
            }
            DependsOn = "[Script]DisablePageFile"
        }

        xWaitforDisk Disk2
        {

            DiskID = 2
            RetryIntervalSec = 60
            RetryCount = 60
            DependsOn = "[Script]MoveAzureTempDrive"
        }

        xDisk DVolume
        {
            DiskID = 2
            DriveLetter = 'D'
            FSLabel = 'Data'
            DependsOn = "[Script]MoveAzureTempDrive"
        }        

        xWaitForADDomain DscForestWait 
        { 
            DomainName = $DomainName 
            DomainUserCredential= $DomainCreds
            RetryCount = $RetryCount 
            RetryIntervalSec = $RetryIntervalSec
        } 

        xDnsServerAddress DnsServerAddress 
        { 
            Address        = $DnsServer
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = 'IPv4'
        }


        xADDomainController BDC 
        { 
            DomainName = $DomainName 
            DomainAdministratorCredential = $DomainCreds 
            SafemodeAdministratorPassword = $DomainCreds
            DatabasePath = "D:\NTDS"
            LogPath = "D:\NTDS"
            SysvolPath = "D:\SYSVOL"
            DependsOn = "[xDisk]DVolume","[xDnsServerAddress]DnsServerAddress"
        }

        xPendingReboot Reboot1
        { 
            Name = "RebootServer"
            DependsOn = "[xADDomainController]BDC"
        }
   }
} 
