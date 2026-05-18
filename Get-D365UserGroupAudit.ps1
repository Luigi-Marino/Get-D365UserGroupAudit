# ============================================================
# Get-D365UserGroupAudit Powershell Script
# ============================================================

# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------
$Repo = "Get-D365UserGroupAudit"
$RepoBase = "https://raw.githubusercontent.com/Luigi-Marino/$Repo/main"
$ModuleNames = @(
    "get_user_groups.psm1",
    "check_compliance.psm1"
)

# ------------------------------------------------------------
# MODULE LOADER
# ------------------------------------------------------------
function Load-RemoteModules {
    param($BaseURL, $Modules)

    foreach ($m in $Modules) {
        $url = "$BaseURL/modules/$m"
        $code = Invoke-RestMethod $url

        $mod = New-Module -ScriptBlock ([ScriptBlock]::Create($code)) -Name $m
        Import-Module $mod -Force
    }
}

# ------------------------------------------------------------
# DETECT EXECUTION METHOD
# ------------------------------------------------------------
if ([string]::IsNullOrWhiteSpace($PSScriptRoot)) {
    Load-RemoteModules -BaseUrl $RepoBase -Modules $ModuleNames
}
else {
    Get-ChildItem "$PSScriptRoot/modules" -Filter *.psm1 |
        ForEach-Object { Import-Module $_.FullName -Force }
}

# ------------------------------------------------------------
# ENTRY POINT
# ------------------------------------------------------------
#Get-UserGroups | Format-Table -AutoSize
Get-MappingFromSharepoint `
    -SharepointPath "\\sensical.sharepoint.com/Support/Documents/General/Corona/LEGO/RBAC/Lego AD Groups_ACC_PRF_PROD_v1.1_240425.xlsx" `
    -SheetName "Mapping - v2.2" `
    -UserResults Get-UserGroups | Format-Table -AutoSize