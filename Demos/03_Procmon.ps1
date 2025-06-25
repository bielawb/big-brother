<# 
    First: run procmon directly using Start-Process
#>

Procmon.exe /NoConnect

Start-Process -FilePath 'C:\bin\Procmon.exe' -ArgumentList "/accepteula /quiet /minimized /loadconfig C:\ProcMon\ConfigExport-ExecutionPolicy.pmc /backingfile C:\Procmon\test.pml" -PassThru

Get-ChildItem -Path C:\ProcMon\test.pml | ForEach-Object -MemberName CreationTime

# Stop capture once we are ready to analyze the results
Start-Process -FilePath 'C:\bin\Procmon.exe' -ArgumentList '/terminate' -Wait

$backingFile = "C:\Procmon\$(Get-Date -Format 'yyyy-MM-dd-HH-mmss').pml"
Start-Process -FilePath 'C:\bin\Procmon.exe' -ArgumentList "/accepteula /quiet /minimized /loadconfig C:\ProcMon\ConfigExport-ExecutionPolicy.pmc /backingfile $backingFile" -PassThru

Get-ChildItem -Path $backingFile | ForEach-Object -MemberName CreationTime

Start-Procmon -ConfigPath C:\ProcMon\ConfigExport-ExecutionPolicy-NoDrop.pmc -LogPath "C:\Procmon\$(Get-Date -Format 'yyyy-MM-dd-HH-mmss').pml"
Stop-Procmon

Start-Procmon -ConfigPath C:\ProcMon\ConfigExport-ExecutionPolicy.pmc -LogPath "C:\Procmon\$(Get-Date -Format 'yyyy-MM-dd-HH-mmss').pml"
Stop-Procmon
