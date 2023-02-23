# HelloID-Task-SA-Target-ActiveDirectory-AccountEnable
######################################################
# Form mapping
$formObject = @{
    UserPrincipalName     = $form.UserPrincipalName
}
try {
    Write-Information "Executing ActiveDirectory action: [EnableAccount] for: $($formObject.UserPrincipalName)]"
    Import-Module ActiveDirectory -ErrorAction Stop
    $user = Get-ADUser -Filter "userPrincipalName -eq '$($formObject.UserPrincipalName)'"
    if ($user) {
        $null = Enable-ADAccount -Identity  $user.SID.value
        $auditLog = @{
            Action            = 'EnableAccount'
            System            = 'ActiveDirectory'
            TargetIdentifier  =  "$($user.SID.value)"
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [EnableAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [EnableAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
    } elseif (-not($user)) {
        $auditLog = @{
            Action            = 'EnableAccount'
            System            = 'ActiveDirectory'
            TargetIdentifier  = ""
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [EnableAccount] for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD"
            IsError           = $true
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [EnableAccount] for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD"
    }

} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'EnableAccount'
        System            = 'ActiveDirectory'
        TargetIdentifier  = ''
        TargetDisplayName =  "$($formObject.UserPrincipalName)"
        Message           = "Could not execute ActiveDirectory action: [EnableAccount] for: [$($formObject.DisplayName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [EnableAccount] for: [$($formObject.DisplayName)], error: $($ex.Exception.Message)"
}
######################################################
