$file    = 'c:\Users\SIMBA\Desktop\YVES PRO\SIBABA FOUNDATION\about.html'
$content = Get-Content $file -Raw

$adminLink = '          <a href="login.html" class="admin-footer-link"><i class="fas fa-lock"></i> Admin</a>'

# Insert admin link before the closing </div> of footer-bottom-links
# The closing tag right after Terms of Use
$content = $content -replace '(Terms of Use</a>\r?\n)(\s*</div>)', "`$1$adminLink`r`n`$2"

Set-Content -Path $file -Value $content -NoNewline -Encoding UTF8
Write-Host "Done - admin link added to about.html"
