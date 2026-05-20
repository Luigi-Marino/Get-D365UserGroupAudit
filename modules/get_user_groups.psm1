function Get-UserGroups {
    $prefix = "AA - LEGO"
    $users = Get-ADUser -Filter * -Properties MemberOf, DisplayName, UserPrincipalName, Title

    $results = foreach ($user in $users) {

        $groupNames = $user.MemberOf | ForEach-Object {
            ($_ -split ",")[0] -replace "^CN=", ""
        }

        # FORCE ARRAY
        $rbacGroups = @($groupNames | Where-Object { $_ -like "$prefix*" })

        if ($rbacGroups.Count -gt 0) {

            $nonProdTokens = @("NON-PROD", "ACC", "TST", "PRF")

            # FORCE ARRAYS EVERYWHERE
            $nonProdGroups = @(
                $rbacGroups | Where-Object {
                    $grp = $_
                    $nonProdTokens | ForEach-Object { $grp -like "*$_*" }
                }
            )

            $powerBiGroups = @(
                $rbacGroups | Where-Object { $_ -like "*ADL*" }
            )

            $prodGroups = @(
                $rbacGroups |
                    Where-Object {
                        $_ -notin $nonProdGroups -and
                        $_ -notin $powerBiGroups
                    }
            )

            [pscustomobject]@{
                Username        = $user.SamAccountName
                DisplayName     = $user.DisplayName
                UPN             = $user.UserPrincipalName
                JobTitle        = $user.Title

                TotalGroupCount = $rbacGroups.Count
                ProdCount       = $prodGroups.Count
                NonProdCount    = $nonProdGroups.Count
                PowerBiCount    = $powerBiGroups.Count

                ProdGroups      = [string]::Join(", ", $prodGroups)
                NonProdGroups   = [string]::Join(", ", $nonProdGroups)
                PowerBiGroups   = [string]::Join(", ", $powerBiGroups)
                AllGroups       = [string]::Join(", ", $rbacGroups)
            }
        }
    }

    return $results
}
