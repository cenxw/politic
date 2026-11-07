$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$books = @(
    Get-ChildItem -LiteralPath $root -File |
        Where-Object { $_.Extension -ieq ".pdf" } |
        Sort-Object Name |
        ForEach-Object {
            [pscustomobject]@{
                title = $_.Name
                file = $_.Name
                size = $_.Length
            }
        }
)

$json = ConvertTo-Json -InputObject $books -Depth 3
$output = "window.BOOKS = $json;`r`n"
$target = Join-Path $root "books.js"
[System.IO.File]::WriteAllText(
    $target,
    $output,
    (New-Object System.Text.UTF8Encoding($false))
)

Write-Host ""
Write-Host "Library updated: $($books.Count) PDF file(s)." -ForegroundColor Green
Write-Host "Open index.html to view the shelf." -ForegroundColor Gray
