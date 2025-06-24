<# 
    What we need:
    - PS remoting enabled
    - Sysinternals installed
    - Some tools: win11
#>

handle.exe Documents
New-Item -Path HKLM:\SOFTWARE\Sysinternals -ItemType Key
New-ItemProperty -Path HKLM:\Software\Sysinternals -PropertyType Dword -Name EulaAccepted -Value 1 -Force

handle Documents
handle -nobanner -v Documents | ConvertFrom-Csv

du -nobanner -c -l 5 'C:\Program Files' | ConvertFrom-Csv

ru -nobanner -c -l 1 HKLM\Software | ConvertFrom-Csv

RAMMap.exe c:\Temp\RamMap.rmp

accesschk.exe C:\Windows\Temp
accesschk.exe -k hklm\SOFTWARE\Policies

autorunsc.exe -nobanner -a b -c

yourfavtool.exe -h

Exit-PSSession

Get-ChildItem C:\bin
