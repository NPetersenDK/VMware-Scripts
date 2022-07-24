<#

Sending NSX-T IDS events to InfluxDB so data is vizualized.
Remember to connect via functions.ps1 before opening.

Using Influx module from here: https://github.com/markwragg/PowerShell-Influx

#>
Import-Module Influx
$nsxtmanager = ""

$IDSEvents = Invoke-RestMethod -Uri "https://$nsxtmanager/policy/api/v1/infra/settings/firewall/security/intrusion-services/ids-events" -Method Post -Headers $Global:headers -UseBasicParsing -SkipCertificateCheck -Body '
    {
    "filters": [
        {
        "field_names": "signature_detail.severity",
        "value": "CRITICAL OR HIGH OR MEDIUM OR LOW OR SUSPICIOUS"
        }
    ]
}'

if ($IDSEvents -eq $null) {
    Write-Host "Failed getting IDS events"
}

else {
    $Critical = $IDSEvents.results | Where-Object {$_.severity -eq "CRITICAL"} | Measure-Object | Select-Object -ExpandProperty Count
    $High = $IDSEvents.results | Where-Object {$_.severity -eq "High"} | Measure-Object | Select-Object -ExpandProperty Count
    $Medium = $IDSEvents.results | Where-Object {$_.severity -eq "Medium"} | Measure-Object | Select-Object -ExpandProperty Count
    $Low = $IDSEvents.results | Where-Object {$_.severity -eq "Low"} | Measure-Object | Select-Object -ExpandProperty Count
    $Suspicious = $IDSEvents.results | Where-Object {$_.severity -eq "Suspicious"} | Measure-Object | Select-Object -ExpandProperty Count

    Write-Influx -Measure IDS_SeverityCount -Tags @{NSXMGR="$($nsxtmanager)"} -Metrics @{"Critical"=$($Critical);"High"=$($High);"Medium"=$($Medium);"Low"=$($Low);"Suspicious"=$($Suspicious)}
    Write-Host "Summary of IDS events sent to Grafana - Critical: $($Critical) - High: $($High) - Medium: $($Medium) - Low: $($Low) - Suspicious: $($Suspicious)"
}
