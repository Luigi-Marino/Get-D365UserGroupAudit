# ============================================================
# Get-Diagnostics Powershell Script
# ============================================================

# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------
$Repo = "Powershell_App_Template"
$RepoBase = "https://raw.githubusercontent.com/Luigi-Marino/$Repo/main"
$ModuleNames = @(
    "template_module.psm1"
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
Test-Module
