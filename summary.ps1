$folderPath = Get-Location
$summaryFile = Join-Path -Path $folderPath -ChildPath "SUMMARY.md"

# 指定要排除的文件夹列表
$excludedFolders = @("images")

# 指定要排除的文件类型
$excludedExtensions = @(".png", ".ps1")

function GenerateSummary {
    param (
        [string]$path,
        [string]$indentation = ""
    )

    $items = Get-ChildItem -Path $path | Sort-Object -Property Name

    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            $itemName = $item.Name + "/"

            # 检查是否需要排除文件夹
            if ($excludedFolders -notcontains $item.Name) {
                Write-Output "$indentation* [$itemName]($itemName)"
                GenerateSummary -path $item.FullName -indentation ("  " + $indentation)
            }
        }
        else {
            $itemName = $item.Name
            $itemPath = $item.FullName.Replace($folderPath, "").Replace("\", "/").TrimStart("/")

            # 检查是否需要排除文件类型
            if ($excludedExtensions -notcontains $item.Extension.ToLower()) {
                Write-Output "$indentation* [$itemName]($itemPath)"
            }
        }
    }
}

$summaryContent = @("<!-- SUMMARY -->", "# Summary", "")
$summaryContent += GenerateSummary -path $folderPath

$summaryContent | Out-File -FilePath $summaryFile -Encoding utf8

Write-Output "summary.md 文件已生成在 $summaryFile"
