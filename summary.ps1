$folderPath = Get-Location
$summaryFile = Join-Path -Path $folderPath -ChildPath "SUMMARY.md"

# 指定要排除的文件夹列表
$excludedFolders = @("images")
# 指定要排除的文件类型
$excludedExtensions = @(".png", ".ps1")
# 指定要排除的文件列表
$excludedFiles = @("SUMMARY.md")

#文件名称检查
# 获取所有的文件
Get-ChildItem -Path $folderPath -Recurse -File | ForEach-Object {
    $newname = $_.Name.Replace(" ", "") # 将文件名中的空格替换为空格
    if ($newname -ne $_.Name) { # 如果文件名发生了更改
        Rename-Item -Path $_.FullName -NewName $newname
    }
}

# 获取所有的文件夹
Get-ChildItem -Path $folderPath -Recurse -Directory | ForEach-Object {
    $newname = $_.Name.Replace(" ", "") # 将文件夹名中的空格替换为空格
    if ($newname -ne $_.Name) { # 如果文件夹名发生了更改
        Rename-Item -Path $_.FullName -NewName $newname
    }
}

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
