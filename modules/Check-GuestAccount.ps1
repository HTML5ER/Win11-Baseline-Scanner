#Requires -Version 5.1
<#
.SYNOPSIS
    Проверяет статус встроенной учетной записи Гостя по ее SID (-501).
#>

function Test-GuestAccountDisabled {
    # Получаем всех локальных пользователей
    $localUsers = Get-LocalUser -ErrorAction Stop
    
    # Ищем пользователя, чей SID заканчивается на -501 (Встроенный Гость в любой локали)
    $guestUser = $localUsers | Where-Object { $_.SID.Value -like "*-501" }

    if (-not $guestUser) {
        throw "Учетная запись с SID *-501 не найдена в системе."
    }

    # Проверяем свойство Enabled
    if ($guestUser.Enabled -eq $true) {
        Write-Host "[CRITICAL] УЯЗВИМОСТЬ: Встроенная учетная запись Гостя ($($guestUser.Name)) АКТИВНА!" -ForegroundColor Red
        return $false
    } else {
        Write-Host "[OK] Учетная запись Гостя ($($guestUser.Name)) надежно отключена." -ForegroundColor Green
        return $true
    }
}

try {
    $isSecure = Test-GuestAccountDisabled
    if (-not $isSecure) {
        exit 1
    }
}
catch {
    Write-Host "CRITICAL: Ошибка при проверке учетной записи Гостя: $($_.Exception.Message)" -ForegroundColor Red
    exit 2
}