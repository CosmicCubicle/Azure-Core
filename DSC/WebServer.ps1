configuration CosmicCubicleNet {

    Import-DscResource -ModuleName 'PSDscResources'
    Import-DscResource -ModuleName 'xDSCDomainjoin'

    $DomainAdmin = Get-AutomationPSCredential -Name 'Watson'
    $DomainName = Get-AutomationVariable -Name 'DomainName'
    
    Node WebServer {
        
        WindowsFeature IIS {
            Ensure               = 'Present'
            Name                 = 'Web-Server'
            IncludeAllSubFeature = $true
        }
        
        xDSCDomainjoin JoinDomain
        {
            Domain = $DomainName
            Credential = $DomainAdmin
            JoinOU = "OU=Unsorted,DC=cosmiccubicle,DC=net"
        }

    }

Node AppServer {
            
    xDSCDomainjoin JoinDomain
    {
        Domain = $DomainName
        Credential = $DomainAdmin
        JoinOU = "OU=Unsorted,DC=cosmiccubicle,DC=net"
    }

}

}