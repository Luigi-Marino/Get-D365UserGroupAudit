function Get-UserGroups {
    $prefix = "AA - LEGO"
    $users = GetADUser -Filter * -Properties MemberOf, DisplayName, UserPrincipalName, Title
    $results = foreach ($user in $users) {
        $groupNames = $user.MemberOf | ForEach-Object { ($_ -split ",")[0] -replace "^CN=", "" }
        $rbacGroups = $groupNames | Where-Object { $_ -like "$prefix*" }

        if ($rbacGroups.Count -gt 0) {
            [pscustomobject]@{
                Username    = $user.SamAccountName
                DisplayName = $user.DisplayName
                UPN         = $user.UserPrincipalName
                JobTitle    = $user.Title
                RBACGroups  = $rbacGroups
            }
        }
    }

    return $results
}

Export-ModuleMember -Function Get-UserGroups