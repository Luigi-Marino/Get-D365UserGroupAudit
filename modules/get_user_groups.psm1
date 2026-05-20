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

            $nonProdGroups = @(
                $rbacGroups | Where-Object {
                    $envToken = ($_ -split " - ")[2]
                    $nonProdTokens -contains $envToken
                }
            )

            $powerBiGroups = @(
                $rbacGroups | Where-Object {
                    $envToken = ($_ -split " - ")[2]
                    $envToken -eq "ADL"
                }
            )

            $prodGroups = @(
                $rbacGroups | Where-Object {
                    $envToken = ($_ -split " - ")[2]
                    $envToken -notin $nonProdTokens -and
                    $envToken -ne "ADL"
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
