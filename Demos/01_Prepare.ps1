<# 
    What we need:
    - PS remoting enabled
    - Sysinternals installed
    - Some tools: win11
#>

Enter-PSSession -Session $session
Get-ChildItem C:\Windows\Temp
Exit-PSSession

Copy-Item -FromSession $session -Path C:\Windows\Temp\Screenshot.png -Destination C:\Windows\Temp
Invoke-Item -Path C:\Windows\Temp\Screenshot.png
if ($demoGodsFailedMe) {
    Invoke-Item -Path C:\Windows\Temp\Screenshot-old.png
}

Enter-PSSession -Session $session
Get-ChildItem C:\Bin