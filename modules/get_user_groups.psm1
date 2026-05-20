function Get-UserGroups {
    $prefix = "AA - LEGO"
    $users = Get-ADUser -Filter * -Properties MemberOf, DisplayName, UserPrincipalName, Title

    $results = foreach ($user in $users) {

        # Extract group names cleanly
        $groupNames = $user.MemberOf | ForEach-Object {
            ($_ -split ",")[0] -replace "^CN=", ""
        }

        # Filter only LEGO groups
        $rbacGroups = $groupNames | Where-Object { $_ -like "$prefix*" }

        if ($rbacGroups.Count -gt 0) {

            # --- NON-PROD groups ---
            $nonProdTokens = @("NON-PROD", "ACC", "TST", "PRF")
            $nonProdGroups = $rbacGroups | Where-Object {
                $grp = $_
                $nonProdTokens | ForEach-Object { $grp -like "*$_*" }
            }

            # --- PowerBI groups ---
            $powerBiGroups = $rbacGroups | Where-Object { $_ -like "*ADL*" }

            # --- PROD groups (everything else) ---
            $prodGroups = $rbacGroups |
                Where-Object {
                    $_ -notin $nonProdGroups -and
                    $_ -notin $powerBiGroups
                }

            [pscustomobject]@{
                Username      = $user.SamAccountName
                DisplayName   = $user.DisplayName
                UPN           = $user.UserPrincipalName
                JobTitle      = $user.Title

                # Counts
                TotalGroupCount = $rbacGroups.Count
                ProdCount       = $prodGroups.Count
                NonProdCount    = $nonProdGroups.Count
                PowerBiCount    = $powerBiGroups.Count

                # Group lists
                ProdGroups      = [string]::Join(", ", $prodGroups)
                NonProdGroups   = [string]::Join(", ", $nonProdGroups)
                PowerBiGroups   = [string]::Join(", ", $powerBiGroups)

                # Raw list if needed
                AllGroups       = [string]::Join(", ", $rbacGroups)
            }
        }
    }

    return $results
}

Export-ModuleMember -Function Get-UserGroups
