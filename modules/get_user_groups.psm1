function Get-UserGroups {
    $prefix = "AA - LEGO"
    $users = GetADUser -Filter * -Properties MemberOf, DisplayName, UserPrincipalName
    $results = foreach ($user in $users) {
        $groupNames = $user.MemberOf | ForEach-Object { ($_ -split ",")[0] -replace "^CN=", "" }
        $rbacGroups = $groupNames | Where-Object { $_ -like "$prefix*" }

        if ($rbacGroups.Count -gt 0) {
            [pscustomobject]@{
                Username    = $user.SamAccountName
                DisplayName = $user.DisplayName
                UPN         = $user.UserPrincipalName
                RBACGroups  = $rbacGroups
            }
        }
    }

    return $results
}

Export-ModuleMember -Function Get-UserGroups