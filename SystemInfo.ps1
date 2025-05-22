# Vlad Imir | hex0de
# https://github.com/hex0de/

# Получение информации о системе
$os = Get-CimInstance Win32_OperatingSystem
$computerSystem = Get-CimInstance Win32_ComputerSystem
$processor = Get-CimInstance Win32_Processor
$memory = Get-CimInstance Win32_PhysicalMemory
$disks = Get-CimInstance Win32_DiskDrive
$logicalDisks = Get-CimInstance Win32_LogicalDisk
$networkAdapters = Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true }
$networkConfigs = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
$timezone = Get-TimeZone

# Формирование данных для вывода
$output = @"
[center][b][size=16]System Information Report[/size][/b][/center]
[hr]

[b][size=14]Operating System Information[/size][/b]
[table]
    [tr][td][b]OS Name:[/b][/td][td]$($os.Caption)[/td][/tr]
    [tr][td][b]Version:[/b][/td][td]$($os.Version)[/td][/tr]
    [tr][td][b]Build:[/b][/td][td]$($os.BuildNumber)[/td][/tr]
    [tr][td][b]Install Date:[/b][/td][td]$($os.InstallDate)[/td][/tr]
    [tr][td][b]Last Boot Time:[/b][/td][td]$($os.LastBootUpTime)[/td][/tr]
[/table]

[b][size=14]Time Zone Information[/size][/b]
[table]
    [tr][td][b]Time Zone:[/b][/td][td]$($timezone.StandardName)[/td][/tr]
    [tr][td][b]Daylight Name:[/b][/td][td]$($timezone.DaylightName)[/td][/tr]
[/table]

[b][size=14]Computer System Information[/size][/b]
[table]
    [tr][td][b]Manufacturer:[/b][/td][td]$($computerSystem.Manufacturer)[/td][/tr]
    [tr][td][b]Model:[/b][/td][td]$($computerSystem.Model)[/td][/tr]
    [tr][td][b]System Type:[/b][/td][td]$($computerSystem.SystemType)[/td][/tr]
    [tr][td][b]Total Physical Memory:[/b][/td][td]$([math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)) GB[/td][/tr]
[/table]

[b][size=14]Processor Information[/size][/b]
[table]
    [tr][td][b]Name:[/b][/td][td]$($processor.Name)[/td][/tr]
    [tr][td][b]Cores:[/b][/td][td]$($processor.NumberOfCores)[/td][/tr]
    [tr][td][b]Threads:[/b][/td][td]$($processor.ThreadCount)[/td][/tr]
    [tr][td][b]Max Clock Speed:[/b][/td][td]$($processor.MaxClockSpeed) MHz[/td][/tr]
[/table]

[b][size=14]Memory Information[/size][/b]
[table]
$($memory | ForEach-Object {
    "[tr][td][b]Bank:[/b][/td][td]$($_.BankLabel)[/td][/tr]
    [tr][td][b]Capacity:[/b][/td][td]$([math]::Round($_.Capacity / 1GB, 2)) GB[/td][/tr]
    [tr][td][b]Speed:[/b][/td][td]$($_.Speed) MHz[/td][/tr]
    [tr][td][b]Type:[/b][/td][td]$($_.TypeDetail)[/td][/tr]"
})
[/table]

[b][size=14]Disk Information[/size][/b]
[table]
$($disks | ForEach-Object {
    "[tr][td][b]Model:[/b][/td][td]$($_.Model)[/td][/tr]
    [tr][td][b]Size:[/b][/td][td]$([math]::Round($_.Size / 1GB, 2)) GB[/td][/tr]
    [tr][td][b]Interface:[/b][/td][td]$($_.InterfaceType)[/td][/tr]"
})
[/table]

[b][size=14]Logical Disk Information[/size][/b]
[table]
$($logicalDisks | ForEach-Object {
    "[tr][td][b]Drive Letter:[/b][/td][td]$($_.DeviceID)[/td][/tr]
    [tr][td][b]File System:[/b][/td][td]$($_.FileSystem)[/td][/tr]
    [tr][td][b]Free Space:[/b][/td][td]$([math]::Round($_.FreeSpace / 1GB, 2)) GB[/td][/tr]
    [tr][td][b]Total Size:[/b][/td][td]$([math]::Round($_.Size / 1GB, 2)) GB[/td][/tr]"
})
[/table]

[b][size=14]Network Adapter Information[/size][/b]
[table]
$($networkAdapters | ForEach-Object {
    "[tr][td][b]Adapter Name:[/b][/td][td]$($_.Name)[/td][/tr]
    [tr][td][b]MAC Address:[/b][/td][td]$($_.MACAddress)[/td][/tr]
    [tr][td][b]Speed:[/b][/td][td]$($_.Speed)[/td][/tr]"
})
[/table]

[b][size=14]Network Configuration Information[/size][/b]
[table]
$($networkConfigs | ForEach-Object {
    "[tr][td][b]Description:[/b][/td][td]$($_.Description)[/td][/tr]
    [tr][td][b]IP Address:[/b][/td][td]$($_.IPAddress -join ', ')[/td][/tr]
    [tr][td][b]Subnet Mask:[/b][/td][td]$($_.IPSubnet -join ', ')[/td][/tr]
    [tr][td][b]Default Gateway:[/b][/td][td]$($_.DefaultIPGateway -join ', ')[/td][/tr]
    [tr][td][b]DNS Servers:[/b][/td][td]$($_.DNSServerSearchOrder -join ', ')[/td][/tr]"
})
[/table]
"@

# Вывод в консоль
Write-Host $output

# Конвертация BB-кодов в HTML
$htmlOutput = @"
<html>
<head>
    <title>System Information Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { text-align: center; color: #333; }
        h2 { color: #444; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        hr { border: 0; border-top: 1px solid #ddd; margin: 20px 0; }
    </style>
</head>
<body>
"@

# Преобразование BB-кодов в HTML
$htmlOutput += $output -replace '\[center\]','<div style="text-align: center;">' `
                     -replace '\[/center\]','</div>' `
                     -replace '\[b\]','<b>' `
                     -replace '\[/b\]','</b>' `
                     -replace '\[size=14\]','<h2>' `
                     -replace '\[size=16\]','<h1>' `
                     -replace '\[/size\]','</h2>' `
                     -replace '\[table\]','<table>' `
                     -replace '\[/table\]','</table>' `
                     -replace '\[tr\]','<tr>' `
                     -replace '\[/tr\]','</tr>' `
                     -replace '\[td\]','<td>' `
                     -replace '\[/td\]','</td>' `
                     -replace '\[hr\]','<hr>'

$htmlOutput += "</body></html>"

# Сохранение в HTML-файл
$htmlOutput | Out-File -FilePath "SystemInfoReport.html" -Encoding UTF8

Write-Host "Report saved to SystemInfoReport.html"