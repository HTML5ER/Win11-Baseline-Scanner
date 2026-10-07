#Requires -Version 5.1
<#
.SYNOPSIS
    Скрипт-оркестратор для автоматического запуска всех модулей аудита.
#>

$ModulesPath = "$PSScriptRoot\modules"

Write-Host "`n=== ЗАПУСК СКАНЕРА БЕЗОПАСНОСТИ WINDOWS 11 ===" -ForegroundColor Cyan
$Modules = Get-ChildItem -Path $ModulesPath -Filter *.ps1

foreach ($Script in $Modules) {
    Write-Host "Запуск модуля $($Script.Name)..." -ForegroundColor Cyan
    & $Script.FullName
    Write-Host "--------------------------------------------------" -ForegroundColor DarkGray

}
exit 0