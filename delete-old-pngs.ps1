$dir  = 'c:\Users\SIMBA\Desktop\YVES PRO\SIBABA FOUNDATION\images'
$keep = @('SIBABA FOUNDATION LOGO@5x.png')

$pngs       = Get-ChildItem -Path $dir -Filter '*.png' | Where-Object { $keep -notcontains $_.Name }
$totalBytes = 0

foreach ($png in $pngs) {
    $jpgPath = [System.IO.Path]::ChangeExtension($png.FullName, '.jpg')
    if (Test-Path $jpgPath) {
        $sizeMB      = [Math]::Round($png.Length / 1MB, 1)
        $totalBytes += $png.Length
        Remove-Item $png.FullName -Force
        Write-Host "DELETED  $($png.Name) — $sizeMB MB freed" -ForegroundColor Green
    } else {
        Write-Host "SKIPPED  $($png.Name) — no .jpg backup exists" -ForegroundColor Yellow
    }
}

$totalMB = [Math]::Round($totalBytes / 1MB, 1)
Write-Host ""
Write-Host "Total space freed: $totalMB MB" -ForegroundColor Cyan
Write-Host "Done." -ForegroundColor Cyan
