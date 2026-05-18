function Get-MappingFromSharepoint {
    param(
        [Parameter(Mandatory)]
        [string]$SharepointPath,

        [Parameter(Mandatory)]
        [string]$SheetName,

        [Parameter(Mandatory)]
        [array]$UserResults
    )

    $rows = Import-Excel -Path $SharepointPath -WorksheetName $SheetName -DataOnly
    $groupColumns = @(
        "AD Group #1",
        "AD Group #2",
        "AD Group #3",
        "AD Group #4",
        "AD Group #5",
        "AD Group #6",
        "AD Group #7",
        "AD Group #8",
        "AD Group #9"
    )

    $mapping = @{}

    foreach ($row in $rows) {

        $jobTitle = $row.JobTitle
        if (-not $jobTitle) { continue }

        $groups = foreach ($col in $groupColumns) {
            $value = $row.$col
            if ($value -and $value.Trim() -ne "") {
                $value.Trim()
            }
        }
        $mapping[$jobTitle] = $groups
    }
    return $mapping
}

Export-ModuleMember -Function Get-MappingFromSharepoint