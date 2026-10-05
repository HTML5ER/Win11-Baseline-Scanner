#Requires -Version 5.1
<#
.SYNOPSIS
    Проверка на предмет включенного RDP и требования NLA.
#>

function Check-RdpDisabled {
    $RegKey = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections
    $RdpStatus = $RegKey.fDenyTSConnections

if ($RdpStatus -eq 1) {
Write-Host "[OK] RDP отключен" -ForegroundColor Green
exit 0
} else {Check-NlaEnabled
}
}
function Check-NlaEnabled {
$NlaKey = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication
$NlaStatus = $NlaKey.UserAuthentication
if ($NlaStatus -eq 1) {
    Write-Host "[WARNING] RDP включен, но защищен NLA" -ForegroundColor Yellow 
    exit 0
    } else { Write-Host "[CRITICAL] RDP открыт всем ветрам без NLA!" -ForegroundColor Red
    exit 1
    }
    }

try {
    Check-RdpDisabled
} 

catch {
    Write-Host "CRITICAL: Ошибка чтения реестра $($_.Exception.Message)" -ForegroundColor Red
    exit 2
   }

    
