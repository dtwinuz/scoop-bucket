# bucket/bitg.json ni haqiqiy Scoop bilan sinaydi: o'rnatish -> MSI va fayllar -> CLI -> o'chirish -> hech narsa qolmagan.
# CI (ci.yml) va autobump.yml ishlatadi; Windows runner'da (administrator) yuradi.
#   pwsh -File bin/test.ps1 [-Version 0.4.0]
param([string]$Version)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

$root = Split-Path -Parent $PSScriptRoot
$manifest = Join-Path $root 'bucket\bitg.json'
$m = Get-Content -Raw -LiteralPath $manifest | ConvertFrom-Json
if (-not $Version) { $Version = $m.version }
if ($m.version -ne $Version) { throw "manifest versiyasi $($m.version), kutilgan ${Version}" }
$upgradeCode = '{80B9514E-EB2C-4EA5-B42A-CECB40A16979}'

function Get-BitgProducts {
    $wi = New-Object -ComObject WindowsInstaller.Installer
    @($wi.GetType().InvokeMember('RelatedProducts', 'GetProperty', $null, $wi, @($upgradeCode)))
}

# Scoop: o'rnatuvchi skript qotirilgan commit'dan, SHA-256 tekshiriladi
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    $commit = '1e2f334083d609986d8c8bc9e31ae8e87c39fab4'
    $want = '94f983b190438311e006b957db7c8422709e0ba62a6c2ac04e278164108f2512'
    $inst = Join-Path ([IO.Path]::GetTempPath()) 'scoop-install.ps1'
    Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/ScoopInstaller/Install/$commit/install.ps1" -OutFile $inst
    $got = (Get-FileHash -Algorithm SHA256 -LiteralPath $inst).Hash.ToLowerInvariant()
    if ($got -ne $want) { throw "Scoop install.ps1 SHA-256 $got, kutilgan $want" }
    & $inst -RunAsAdmin
    $env:PATH = "$env:USERPROFILE\scoop\shims;$env:PATH"
}
scoop --version

if ((Get-BitgProducts).Count -ne 0) { throw "bitg sinovdan oldin o'rnatilgan" }

Write-Host "== scoop install bitg ${Version}"
scoop install $manifest
if ($LASTEXITCODE) { throw "scoop install: $LASTEXITCODE" }
scoop info bitg | Out-String | Write-Host

$codes = @(Get-BitgProducts)
if ($codes.Count -ne 1) { throw "o'rnatilgan bitg MSI soni $($codes.Count), kutilgan 1" }
$wi = New-Object -ComObject WindowsInstaller.Installer
$ver = $wi.GetType().InvokeMember('ProductInfo', 'GetProperty', $null, $wi, @($codes[0], 'VersionString'))
if ($ver -ne $Version) { throw "MSI versiyasi $ver, kutilgan ${Version}" }

$app = Join-Path $env:ProgramFiles 'bitg'
foreach ($f in 'bitg.exe', 'bitg-settings.exe', "ime\$Version\bitg_tsf.dll", "ime\$Version\x86\bitg_tsf.dll") {
    if (-not (Test-Path -LiteralPath (Join-Path $app $f))) { throw "${f} o'rnatilmagan" }
}
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$out = & (Join-Path $app 'bitg.exe') "O'zbekiston shaharlari"
if ($out -ne 'Özbekiston şaharlari') { throw "bitg CLI: '$out'" }
Write-Host "bitg $ver o'rnatildi, CLI: $out"

Write-Host '== scoop uninstall bitg'
scoop uninstall bitg
if ($LASTEXITCODE) { throw "scoop uninstall: $LASTEXITCODE" }
if (@(Get-BitgProducts).Count -ne 0) { throw "scoop uninstall dan keyin bitg MSI qoldi" }
if (Test-Path -LiteralPath (Join-Path $app 'bitg.exe')) { throw "scoop uninstall dan keyin bitg.exe qoldi" }
if (Test-Path -LiteralPath "$env:USERPROFILE\scoop\apps\bitg") { throw "Scoop apps\bitg qoldi" }
Write-Host "bitg ${Version}: o'rnatish va o'chirish o'tdi"
