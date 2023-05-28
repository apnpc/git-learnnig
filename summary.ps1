$folderPath = Get-Location
$summaryFile = Join-Path -Path $folderPath -ChildPath "SUMMARY.md"

# 指定要排除的文件夹列表
$excludedFolders = @("images")

# 指定要排除的文件类型
$excludedExtensions = @(".png", ".ps1")

# 指定要排除的文件列表
$excludedFiles = @("SUMMARY.md")

function GenerateSummary {
    param (
        [string]$path,
        [string]$indentation = ""
    )

    $items = Get-ChildItem -Path $path | Sort-Object -Property Name

    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            if ($excludedFolders -notcontains $item.Name) {
                $itemName = $item.Name + "/"
                Write-Output "$indentation* [$itemName]($itemName)"
                GenerateSummary -path $item.FullName -indentation ("  " + $indentation)
            }
        }
        else {
            if ($excludedExtensions -notcontains $item.Extension.ToLower() -and $excludedFiles -notcontains $item.Name) {
                $itemName = $item.Name -replace '\.[^.]+$' -replace '\s', ''
                $itemPath = $item.FullName.Replace($folderPath, "").Replace("\", "/").TrimStart("/")
                Write-Output "$indentation* [$itemName]($itemPath)"
            }
        }
    }
}

$summaryContent = @("<!-- SUMMARY -->", "# Summary", "")
$summaryContent += GenerateSummary -path $folderPath

$summaryContent | Out-File -FilePath $summaryFile -Encoding utf8

Write-Output "summary.md 文件已生成在 $summaryFile"
