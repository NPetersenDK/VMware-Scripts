<#

NSX-T Functioning functions
I use stuff from PS Core (7.x) so remember to use that, instead of the usual old stuff.

#>

function Connect-NSXTApi {
    $username = "admin"
    $nsxtmanager = ""

    #$username = Read-Host -Prompt "Input Username"
    $password = Read-Host -Prompt "Input Password" -AsSecureString
    
    $PlainPassword  =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    $httpcred = "$($username):$($PlainPassword)"
    $Base64Creds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($httpcred))

    $Global:headers = @{ Authorization = "Basic $Base64Creds" }
    $global:headers.Add("X-Allow-Overwrite", "true")
    $global:headers.Add("Accept", "application/json")
    $global:headers.Add("Content-type", "application/json")

    $PolicyURL = "https://$nsxtmanager/api/v1/node/services/policy/status"


    Write-Host "Checking that everything is working as expected"

    $GetPolicy = $null
    try {
        $GetPolicy = Invoke-WebRequest -Uri $PolicyURL -Method Get -Headers $Headers -UseBasicParsing -SkipCertificateCheck
        if ($GetPolicy -eq $null) {
            Write-Host "Error connecting"
            break
        }

        else {
            Write-Host "Everything worked!"
        }
    }
    catch {
        Write-Host "Error connecting.."
    }
}