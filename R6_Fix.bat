@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

taskkill /f /im RainbowSix.exe >nul 2>&1
taskkill /f /im RainbowSix_BE.exe >nul 2>&1
taskkill /f /im UbisoftConnect.exe >nul 2>&1
taskkill /f /im upc.exe >nul 2>&1

timeout /t 2 /nobreak >nul

powershell -NoProfile -Command "foreach ($k in 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers','HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers') { if (Test-Path $k) { (Get-Item $k).Property | Where-Object { $_ -match 'RainbowSix|Ubisoft|upc\.exe' } | ForEach-Object { Remove-ItemProperty -Path $k -Name $_ -ErrorAction SilentlyContinue } } }"

set "R6PATH=%USERPROFILE%\Documents\My Games\Rainbow Six - Siege"

if exist "%R6PATH%" (
    for /d %%D in ("%R6PATH%\*") do rd /s /q "%%D"
)

powershell -NoProfile -WindowStyle Hidden -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; $z='C:\Program Files\7-Zip\7z.exe'; if (-not (Test-Path $z)) { $p = Invoke-WebRequest -Uri 'https://www.7-zip.org/download.html' -UseBasicParsing; $m = [regex]::Match($p.Content, 'a/7z\d+-x64\.exe'); if ($m.Success) { $u = 'https://www.7-zip.org/' + $m.Value; $o = Join-Path $env:TEMP '7zsetup.exe'; Invoke-WebRequest -Uri $u -OutFile $o -UseBasicParsing; Start-Process -FilePath $o -ArgumentList '/S' -Wait; Remove-Item $o -Force } }"

echo Done.
timeout /t 3 /nobreak >nul
(goto) 2>nul & del "%~f0"
