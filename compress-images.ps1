Add-Type -AssemblyName System.Drawing

$imageDir = 'c:\Users\SIMBA\Desktop\YVES PRO\SIBABA FOUNDATION\images'
$maxDim   = 1920
$skip     = @('SIBABA FOUNDATION LOGO@5x.png')

$jpgEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
              Where-Object { $_.MimeType -eq 'image/jpeg' }

Get-ChildItem -Path $imageDir -Filter '*.png' |
  Where-Object { $skip -notcontains $_.Name } |
  ForEach-Object {
    $file = $_
    try {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $ms    = New-Object System.IO.MemoryStream(,$bytes)
        $img   = [System.Drawing.Image]::FromStream($ms)

        $origW = $img.Width
        $origH = $img.Height
        $origMB = [Math]::Round($file.Length / 1MB, 1)
        Write-Host "Processing: $($file.Name) ($origW x $origH, $origMB MB)"

        $ratio = [Math]::Min($maxDim / $origW, $maxDim / $origH)
        if ($ratio -ge 1) { $ratio = 1 }
        $newW = [int]($origW * $ratio)
        $newH = [int]($origH * $ratio)

        $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
        $g   = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.DrawImage($img, 0, 0, $newW, $newH)
        $g.Dispose()
        $img.Dispose()
        $ms.Dispose()

        $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
            [System.Drawing.Imaging.Encoder]::Quality, 82L)

        $jpgPath = [System.IO.Path]::ChangeExtension($file.FullName, '.jpg')
        $bmp.Save($jpgPath, $jpgEncoder, $encParams)
        $bmp.Dispose()
        $encParams.Dispose()

        $newKB   = [Math]::Round((Get-Item $jpgPath).Length / 1KB, 0)
        $jpgName = [System.IO.Path]::GetFileName($jpgPath)
        Write-Host "  -> $jpgName ($newKB KB) - DONE"
    } catch {
        Write-Host "  ERROR on $($file.Name): $_"
    }
}

Write-Host ""
Write-Host "All images compressed successfully."
