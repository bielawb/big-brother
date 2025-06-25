<# 
    What we need:
    - pktmon
    - netsh
    - PowerShell?
#>

if ($env:COMPUTERNAME -ne 'Win11') {
    Enter-PSSession -Session $session
} else {
    Write-Warning 'We are IN already!'
}

PktMon.exe list --all

$output = PktMon.exe list --all --json | ConvertFrom-Json
($tcpip = $output.
    Where{ $_.Group -match 'Intel' }.
    Components.
    Where{ $_.Name -eq 'TCPIP' })

# Starting capture using TCPv4 only...
Set-Location -Path C:\RecycleBin
PktMon.exe start --capture --comp $tcpip.Id --file-name "PktMonCapture$(Get-Date -Format yyyyMMdd-HHmmss).etl"
# Reproduce the issue...
gpupdate.exe /force
PktMon.exe stop

# Convert to format that can be used with WireShark...
PktMon.exe etl2pcap .\PktMonCapture20250625-164027.etl

Exit-PSSession

Copy-Item -FromSession $session -Path 'C:\RecycleBin\*.pcapng' -Destination C:\RecycleBin

Enter-PSSession -ComputerName win11.igo.com -Credential $creds

# Test remote access....
Test-NetConnection -ComputerName dc01.igo.com -Port 445
Get-ChildItem -Path \\igo.com\SYSVOL

New-PSDrive -Name Sysvol -PSProvider FileSystem -Root \\dc01.igo.com\SYSVOL -Credential igo\bielawb

Get-ChildItem -Path Sysvol:\igo.com\

Get-CimClass -Namespace root/Microsoft/Windows/ManagementTools -ClassName MSFT_*
Get-CimInstance -Namespace root/Microsoft/Windows/ManagementTools -ClassName MSFT_MTProcess