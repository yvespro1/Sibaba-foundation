$base = 'c:\Users\SIMBA\Desktop\YVES PRO\SIBABA FOUNDATION'
$images = Get-ChildItem "$base\images" | Select-Object -ExpandProperty Name
$htmlFiles = @('index.html','about.html','education-services.html','login.html','admin.html','privacy.html','terms.html')
$errors = @()
$ok     = @()

# ── 1. Check every HTML file exists ──────────────────────────
Write-Host "`n=== FILE EXISTS CHECK ===" -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
  $fp = Join-Path $base $file
  if (Test-Path $fp) {
    Write-Host "  OK   $file" -ForegroundColor Green
  } else {
    Write-Host "  MISSING  $file" -ForegroundColor Red
    $errors += "MISSING FILE: $file"
  }
}

# ── 2. Image reference check ─────────────────────────────────
Write-Host "`n=== IMAGE REFERENCE CHECK ===" -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
  $fp = Join-Path $base $file
  if (!(Test-Path $fp)) { continue }
  $content = Get-Content $fp -Raw
  $matches2 = [regex]::Matches($content, 'images/[\w\s@%.+-]+\.(png|jpg|jpeg|gif|webp|svg)')
  foreach ($m in $matches2) {
    $raw  = $m.Value -replace 'images/', '' -replace '%20',' '
    $full = Join-Path "$base\images" $raw
    if (Test-Path $full) {
      # ok - silent
    } else {
      Write-Host "  BROKEN IMG  $file -> images/$raw" -ForegroundColor Red
      $errors += "BROKEN IMAGE in ${file}: images/$raw"
    }
  }
}
if ($errors.Count -eq 0) { Write-Host "  All image refs valid" -ForegroundColor Green }

# ── 3. Internal link check ────────────────────────────────────
Write-Host "`n=== INTERNAL LINK CHECK ===" -ForegroundColor Cyan
$brokenLinks = 0
foreach ($file in $htmlFiles) {
  $fp = Join-Path $base $file
  if (!(Test-Path $fp)) { continue }
  $content = Get-Content $fp -Raw
  $hrefs = [regex]::Matches($content, 'href="([^"]+)"')
  foreach ($h in $hrefs) {
    $link = $h.Groups[1].Value
    if ($link -match '^https?://' -or $link -match '^#' -or $link -match '^mailto:' -or $link -match '^//' ) { continue }
    $page = ($link -split '#')[0] -split '\?' | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($page)) { continue }
    $linkPath = Join-Path $base $page
    if (!(Test-Path $linkPath)) {
      Write-Host "  BROKEN LINK  $file -> $page" -ForegroundColor Red
      $errors += "BROKEN LINK in ${file}: $page"
      $brokenLinks++
    }
  }
}
if ($brokenLinks -eq 0) { Write-Host "  All internal links valid" -ForegroundColor Green }

# ── 4. Script / src check ─────────────────────────────────────
Write-Host "`n=== SCRIPT/SRC CHECK ===" -ForegroundColor Cyan
$brokenSrc = 0
foreach ($file in $htmlFiles) {
  $fp = Join-Path $base $file
  if (!(Test-Path $fp)) { continue }
  $content = Get-Content $fp -Raw
  $srcs = [regex]::Matches($content, 'src="(?!https?://)(?!//)([^"]+)"')
  foreach ($s in $srcs) {
    $src = ($s.Groups[1].Value -split '\?')[0]
    if ([string]::IsNullOrWhiteSpace($src)) { continue }
    $srcPath = Join-Path $base $src
    if (!(Test-Path $srcPath)) {
      Write-Host "  BROKEN SRC  $file -> $src" -ForegroundColor Red
      $errors += "BROKEN SRC in ${file}: $src"
      $brokenSrc++
    }
  }
}
if ($brokenSrc -eq 0) { Write-Host "  All local src refs valid" -ForegroundColor Green }

# ── 5. firebase.js validation ─────────────────────────────────
Write-Host "`n=== FIREBASE.JS VALIDATION ===" -ForegroundColor Cyan
$fbPath = Join-Path $base 'firebase.js'
if (Test-Path $fbPath) {
  $fb = Get-Content $fbPath -Raw
  $checks = @{
    'initializeApp imported' = 'initializeApp'
    'getAuth imported'       = 'getAuth'
    'getFirestore imported'  = 'getFirestore'
    'auth exported'          = 'export const auth'
    'db exported'            = 'export const db'
    'apiKey present'         = 'apiKey'
    'projectId present'      = 'projectId'
  }
  foreach ($k in $checks.Keys) {
    if ($fb -match [regex]::Escape($checks[$k])) {
      Write-Host "  OK   $k" -ForegroundColor Green
    } else {
      Write-Host "  FAIL $k" -ForegroundColor Red
      $errors += "firebase.js: missing $k"
    }
  }
} else {
  Write-Host "  MISSING  firebase.js" -ForegroundColor Red
  $errors += "MISSING: firebase.js"
}

# ── 6. admin.html auth guard check ────────────────────────────
Write-Host "`n=== ADMIN.HTML SECURITY CHECK ===" -ForegroundColor Cyan
$adminPath = Join-Path $base 'admin.html'
if (Test-Path $adminPath) {
  $admin = Get-Content $adminPath -Raw
  if ($admin -match 'onAuthStateChanged') {
    Write-Host "  OK   Auth guard present (onAuthStateChanged)" -ForegroundColor Green
  } else {
    Write-Host "  FAIL Auth guard MISSING" -ForegroundColor Red
    $errors += "admin.html: auth guard missing"
  }
  if ($admin -match 'login\.html') {
    Write-Host "  OK   Redirect to login.html on unauthorized" -ForegroundColor Green
  } else {
    Write-Host "  FAIL No redirect to login.html" -ForegroundColor Red
  }
}

# ── 7. Unused + large images ──────────────────────────────────
Write-Host "`n=== IMAGE SIZE CHECK ===" -ForegroundColor Cyan
Get-ChildItem "$base\images" | Sort-Object Length -Descending | ForEach-Object {
  $sizeKB = [Math]::Round($_.Length / 1KB, 0)
  $sizeMB = [Math]::Round($_.Length / 1MB, 2)
  if ($_.Length -gt 1MB) {
    Write-Host "  LARGE ($sizeMB MB)  $($_.Name)" -ForegroundColor Yellow
  } else {
    Write-Host "  OK    ($sizeKB KB)  $($_.Name)" -ForegroundColor Green
  }
}

# ── Final Summary ──────────────────────────────────────────────
Write-Host "`n=============================" -ForegroundColor Cyan
Write-Host "     SCAN COMPLETE" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
if ($errors.Count -eq 0) {
  Write-Host "`n  NO ERRORS FOUND - Site is clean!" -ForegroundColor Green
} else {
  Write-Host "`n  $($errors.Count) ISSUE(S) FOUND:" -ForegroundColor Red
  foreach ($e in $errors) { Write-Host "   - $e" -ForegroundColor Red }
}
