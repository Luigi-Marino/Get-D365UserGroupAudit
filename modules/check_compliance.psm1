function Get-MappingFromSharepoint {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false

    $workbook = $excel.Workbooks.Open("https://sensical.sharepoint.com/:x:/s/Support/IQD372CrP5u8Qr7lBvFJ8iPsAZgp92c-kfvarL93nI0Cluw?e=sheJ7U")
    $sheet = $workbook.Worksheets.Item("Mapping - v2.2")

    # Read used range
    $range = $sheet.UsedRange.Value2

    # Close Excel
    $workbook.Close($false)
    $excel.Quit()

    # Convert to objects
    $headers = $range[1]
    $data = for ($i = 2; $i -le $range.GetLength(0); $i++) {
        $obj = [ordered]@{}
        for ($j = 1; $j -le $headers.Length; $j++) {
            $obj[$headers[$j]] = $range[$i, $j]
        }
        [pscustomobject]$obj
    }

    return $data

}

Export-ModuleMember -Function Get-MappingFromSharepoint