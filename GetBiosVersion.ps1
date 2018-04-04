<#
.SYNOPSIS
get BIOS version.

.DESCRIPTION
Return the BIOS version.

.FUNCTIONALITY
On demand

.OUTPUTS
BIOSVersion: Version of the BIOS version installed on the device

.NOTES
Context: LocalSystem
Version 1.0.0.0 

#>


#$ErrorActionPreference = "silentlyContinue"
# Check if script is running on nexthink Client
function Get-NexthinkStatus() {
    # send info back to Nexthink engine:
    $result=$false
    $params = Get-ItemProperty "HKLM:\System\CurrentControlSet\Services\Nexthink Coordinator\params" -ErrorAction 0
    if ($params.tcp_status -match "connected") {
        try {
            $dll = "$env:Nexthink\RemoteActions\nxtremoteactions.dll"
            if (Test-path $dll) {
                Add-Type -Path $dll
                $result = $true
            }
        } catch {}
    }
    return $result
}

# Global trap of error
trap {
    $e=$Error[0]
    $host.ui.WriteErrorLine('Error :'+ $e.Exception.Message + ": [L"+$e.InvocationInfo.ScriptLineNumber + "/C" + $e.InvocationInfo.OffsetInLine + "]")  
    exit 1
}


function as_local_system() {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    return $id.User.ToString() -eq "S-1-5-18"
}

if (-not $(as_local_system)) {
    throw "This script must be run as LocalSystem"
}

#
# 1) Get BIOS info
#

$systemBiosVersion = (Get-WmiObject -Class win32_bios).SMBIOSBIOSVersion

#
# 5) Return data
#

try {
    if(Get-NexthinkStatus) {
        [Nxt]::WriteOutputString("BIOSVersion", "$systemBiosVersion")
        exit 0
    }
} 
catch {}
Write-Output $systemBiosVersion 
# SIG # Begin signature block
# MIIMXQYJKoZIhvcNAQcCoIIMTjCCDEoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUsgUYG2SSnUE2CxLTrBA40sN+
# DxqggglTMIIEdDCCA1ygAwIBAgIBAzANBgkqhkiG9w0BAQUFADCBvjELMAkGA1UE
# BhMCRlIxDzANBgNVBAgTBkZyYW5jZTEdMBsGA1UEBxMUQm91bG9nbmUtQmlsbGFu
# Y291cnQxHjAcBgNVBAoTFUxhIEZyYW5jYWlzZSBEZXMgSmV1eDESMBAGA1UECxMJ
# TEZESiBJU0VDMSowKAYDVQQDEyFMYSBGcmFuY2Fpc2UgRGVzIEpldXggLSBBQyBS
# YWNpbmUxHzAdBgkqhkiG9w0BCQEWEHNlY29wZXJAbGZkai5jb20wHhcNMDUwMTE0
# MTc0NDE5WhcNMjUwMTA5MTc0NDE5WjCByzELMAkGA1UEBhMCRlIxDzANBgNVBAgT
# BkZyYW5jZTEdMBsGA1UEBxMUQm91bG9nbmUtQmlsbGFuY291cnQxHjAcBgNVBAoT
# FUxhIEZyYW5jYWlzZSBEZXMgSmV1eDESMBAGA1UECxMJTEZESiBJU0VDMTcwNQYD
# VQQDEy5MYSBGcmFuY2Fpc2UgRGVzIEpldXggLSBBQyBTaWduYXR1cmUgUHJvZ3Jh
# bW1lMR8wHQYJKoZIhvcNAQkBFhBzZWNvcGVyQGxmZGouY29tMIGfMA0GCSqGSIb3
# DQEBAQUAA4GNADCBiQKBgQC3OJ6csswr2soUXhkj38CM4dNN8LFWZV2KdyUrHjha
# BGdx53OYQxRtlv27QtAnwPR7NOH3wFZGcWIjnxxitkLTGagrLc2DxaU5ePUy+SpU
# tezxbFfDYP9sO+viv1qCuVD/1Oot2v3U+P6ISli3Zhn6XD+gm3ssfZLL4k/g93VN
# bQIDAQABo4HxMIHuMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgEGMGoGA1UdHwRj
# MGEwLqAsoCqGKGh0dHBzOi8vY2VydHMuZmRqZXV4LmNvbS9jYS9yb290L2NybC5j
# cmwwL6AtoCuGKWh0dHBzOi8vY2VydHMucHJvZC5mZGouZnIvY2Evcm9vdC9jcmwu
# Y3JsMEIGCWCGSAGG+EIBDQQ1FjNUaGlzIGNlcnRpZmljYXRlIGlzIHVzZWQgZm9y
# IGlzc3VlaW5nIHN1Yi1DQSBjZXJ0cy4wIQYJYIZIAYb4QgECBBQWEkBjcnRfcm9v
# dF9iYXNlX3VybDANBgkqhkiG9w0BAQUFAAOCAQEATwm7OA/XusW4p76dXvHhq3yT
# /WOkK+hoK1IEtGUHdAezqcP8FYQhQ0ivXMHytXtOP0DoagDy14JBUeoUu9jZLBUV
# /T5NAW1XD4DqsS5bsRxB8/tlkahIROq5pNPftel1wGjH4N6/bCOw4SpICuOdvgqZ
# 36KjtZL5PhBzyRlcwgoUltukIF2uAXvKHS9c15R1vWpRxxw27LiP9kOOq/yYNWj3
# Pr2za3erkUYPuswc+Qgjni5f0ocosvFCZmggEwpBfGDocywLhTjIS0mFBF/OOIDh
# EGdoDgkHPBVFckzpfmkiaVFDe+fGyBr9wxt0q+8huqwQjSVTV2z/CFOE1u3HEjCC
# BNcwggRAoAMCAQICAgDmMA0GCSqGSIb3DQEBCwUAMIHLMQswCQYDVQQGEwJGUjEP
# MA0GA1UECBMGRnJhbmNlMR0wGwYDVQQHExRCb3Vsb2duZS1CaWxsYW5jb3VydDEe
# MBwGA1UEChMVTGEgRnJhbmNhaXNlIERlcyBKZXV4MRIwEAYDVQQLEwlMRkRKIElT
# RUMxNzA1BgNVBAMTLkxhIEZyYW5jYWlzZSBEZXMgSmV1eCAtIEFDIFNpZ25hdHVy
# ZSBQcm9ncmFtbWUxHzAdBgkqhkiG9w0BCQEWEHNlY29wZXJAbGZkai5jb20wHhcN
# MTgwMTIyMTYxMjEzWhcNMjMwMTIxMTYxMjEzWjCBqDELMAkGA1UEBhMCRlIxDzAN
# BgNVBAgMBkZSQU5DRTEYMBYGA1UEBwwPTW91c3N5IGxlIHZpZXV4MR4wHAYDVQQK
# DBVMYSBGcmFuY2Fpc2UgRGVzIEpldXgxDDAKBgNVBAsMA0RORTEeMBwGA1UEAwwV
# bnh0YXNzaWduLnByb2QuZmRqLmZyMSAwHgYJKoZIhvcNAQkBFhFsdGF1cGlhY0Bs
# ZmRqLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL5TNiXlpodP
# jg3wv2B0F9kMcVWEE3gBGoJbW06B6SKdYMVBQ6ba/XxaLkOGcjp8DUOepbLTsh4I
# ffmW7W+yZuKWAe0VTwyGa16sU6mqVEw7y+tVK5WS1otguK8tSsBOK3RWYraqD9So
# xsc3XUPnIcPlmvkscdgOQhmCBBfvHLWT9So5XT7UkSl9Xs214Akw4JjmTTEphlmb
# S+rqyE5PxvkGdyz7ZOVSBe4KLoYafv3a+bXSwx5fxpCSbx+5KzbVIVBEQU8HFWSb
# TGW5ixDK9vYCyEK8ZBbjJ+4K9D7hz8TnR4fiWhYjGTLHge5gsjSi2YAhw9MJOXA0
# qO36uNukYuUCAwEAAaOCAWUwggFhMAsGA1UdDwQEAwIGwDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBYBgNVHRIEUTBPhiRodHRwOi8vY2VydHMubGZkai5jb20vY2Evc2ln
# bi9jYS5jcnSGJ2h0dHA6Ly9jZXJ0cy5wcm9kLmZkai5mci9jYS9zaWduL2NhLmNy
# dDBmBgNVHR8EXzBdMCugKaAnhiVodHRwOi8vY2VydHMubGZkai5jb20vY2Evc2ln
# bi9jcmwuY3JsMC6gLKAqhihodHRwOi8vY2VydHMucHJvZC5mZGouZnIvY2Evc2ln
# bi9jcmwuY3JsMEUGCWCGSAGG+EIBDQQ4FjZUaGlzIGNlcnRpZmljYXRlIGlzIHVz
# ZWQgZm9yIENvZGVTaWduaW5nQ2VydHMgc2lnbmluZy4wIQYJYIZIAYb4QgECBBQW
# EkBjcnRfc2lnbl9iYXNlX3VybDARBglghkgBhvhCAQEEBAMCBBAwDQYJKoZIhvcN
# AQELBQADgYEAZRxUbMgwzp9GJyXcPOffsfB38YcJzOsXx3L9vTVR1HDnmsHY4aAx
# 86HXOA7Cd7pYNgeMQvHul0Rz6KlRnP0/nWWfgCy2JuH6MJM5buE7FO4t8rdKPMTD
# W9sC2SxcwCkF9tM+0DoJVuO/Evpcm2DX3j/Xgo/N0pZMP5MJFTltUJ8xggJ0MIIC
# cAIBATCB0jCByzELMAkGA1UEBhMCRlIxDzANBgNVBAgTBkZyYW5jZTEdMBsGA1UE
# BxMUQm91bG9nbmUtQmlsbGFuY291cnQxHjAcBgNVBAoTFUxhIEZyYW5jYWlzZSBE
# ZXMgSmV1eDESMBAGA1UECxMJTEZESiBJU0VDMTcwNQYDVQQDEy5MYSBGcmFuY2Fp
# c2UgRGVzIEpldXggLSBBQyBTaWduYXR1cmUgUHJvZ3JhbW1lMR8wHQYJKoZIhvcN
# AQkBFhBzZWNvcGVyQGxmZGouY29tAgIA5jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUwFf39mne
# FfxTrz2Ef6bDfV1rCFIwDQYJKoZIhvcNAQEBBQAEggEAaEcca6v79Tq52QDl1WgA
# rh6S4tduEIXcLiLXQSMS80QcDy5pI66pz2um109efO6TLqDKdqTJ1/gAjZbX3TvO
# yeVB7251ReMFUiK2zoK0gW8A2c7o9SMEFCwiNgnnIpCt7n4v1Ggro0Sk6qpbjlUG
# +JWk8bcsbDeuCbJDL5h+fIAYrZmO5K4aG0wjHM3SA0k+BOjUZqWkXzHQS/4Cepej
# xu8dv/lyF4aC5qlyKQaxxst7q+G7vCd1f1UJzRWfktInFCXaP79oyJU6QpwaVroJ
# s4tPENJyonCBMr1UJ8n6T3eZlXtpnYVdbZcDoa5yLIKI89em8MkqWZbgOX3U33Fw
# xg==
# SIG # End signature block
