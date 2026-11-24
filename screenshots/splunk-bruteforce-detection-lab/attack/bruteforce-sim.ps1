<#
  Brute-force simulation (MITRE ATT&CK T1110)
  FOR ISOLATED LAB USE ONLY. Run as Administrator on the monitored endpoint.
  Creates a local test account, then validates a wrong password repeatedly
  to generate Event ID 4625 (failed logon) and, once the lockout threshold
  is reached, Event ID 4740 (account locked out).
  Prerequisite: secpol.msc > Account Lockout Policy > threshold = 3
#>
New-LocalUser -Name "SplunkVictim" -Description "Lab test account" -NoPassword

$TargetUser  = "SplunkVictim"
$BadPassword = "WrongPassword123!"

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$Ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext(
    [System.DirectoryServices.AccountManagement.ContextType]::Machine)

for ($i = 1; $i -le 5; $i++) {
    Write-Host "Attempt $i : Validating credentials..."
    $IsValid = $Ctx.ValidateCredentials($TargetUser, $BadPassword)
    if (-not $IsValid) { Write-Host "Login failed (Event 4625)" -ForegroundColor Yellow }
    Start-Sleep -Seconds 1
}

# Cleanup when finished:
# Remove-LocalUser -Name "SplunkVictim"
