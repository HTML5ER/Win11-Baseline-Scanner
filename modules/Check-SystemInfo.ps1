#Requires -Version 5.1
<#
.SYNOPSIS
    Проверяет права администратора и выводит название ОС и номер билда.
#>

function Test-IsAdmin {
    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Show-OsInfo {
    $os   = Get-CimInstance -ClassName Win32_OperatingSystem
    $name = $os.Caption -replace '^Microsoft\s+', ''
    Write-Host "[OK] Система: $name | Билд: $($os.BuildNumber)" -ForegroundColor Green
}

if (-not (Test-IsAdmin)) {
    Write-Host "CRITICAL: Требуются права администратора" -ForegroundColor Red
    exit 1
}

try {
    Show-OsInfo
}
catch {
    Write-Host "CRITICAL: Не удалось получить данные об ОС: $($_.Exception.Message)" -ForegroundColor Red
    exit 2
}
