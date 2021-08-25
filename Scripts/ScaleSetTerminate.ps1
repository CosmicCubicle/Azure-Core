$ImdsServer = "http://169.254.169.254"
$InstanceEndpoint = $ImdsServer + "/metadata/instance"

function Query-InstanceEndpoint
{
    $uri = $InstanceEndpoint + "?api-version=2019-03-11"
    $endpoint = Invoke-RestMethod -Method GET -Proxy $Null -Uri $uri -Headers @{"Metadata"="True"}
    return $endpoint
}

$endpoint = Query-InstanceEndpoint
$endpoint | ConvertTo-JSON -Depth 99

$events = Invoke-RestMethod -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/scheduledevents?api-version=2019-01-01" -Headers @{"Metadata"="True"}
$events | ConvertTo-JSON -Depth 99
