#Requires -Version 5.1
<#
.SYNOPSIS
    Проверяет наличие включенного UAC.
#>

$RegKey = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System

function Check-EnableLUA {
    $UacStatus = $RegKey.EnableLUA
    if ($UacStatus -eq 1) {
        return $true
    }
    else {
        return $false
    }
}
function Check-UacBehavior {
    $UacBehavior = $RegKey.ConsentPromptBehaviorAdmin
    if ($UacBehavior -eq 2) {
        return $true
        }
    elseif ($UacBehavior -ne 2 -and $UacBehavior -ne 0) {
        return "Warning"
        }
    else {
        return $false
    }
}
function Check-Uac {
   $Check1 = Check-EnableLUA
   if ($Check1 -eq $false) {
    Write-Host "[CRITICAL] УЯЗВИМОСТЬ: UAC полностью отключен (EnableLUA=0)!" -ForegroundColor Red
    exit 1
    }
   else {
    $Check2 = Check-UacBehavior
    if ($Check2 -eq $true) {
         Write-Host "[OK] UAC включен и работает в безопасном режиме." -ForegroundColor Green
         exit 0
    }
    elseif ($Check2 -eq "Warning") {
         Write-Host "[WARNING] UAC работает, но с нестандартными настройками." -ForegroundColor Yellow
         exit 0
    }
    else {
     Write-Host "[CRITICAL] УЯЗВИМОСТЬ: UAC разрешает авто-повышение прав без запроса!" -ForegroundColor Red
     exit 1
    }
   }
}

try {
    Check-Uac
}
catch {
     Write-Host "CRITICAL: Ошибка чтения реестра! $($_.Exception.Message)" -ForegroundColor Red
    exit 2
}
