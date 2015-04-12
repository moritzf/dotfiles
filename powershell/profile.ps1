Write-Host "Hi Moritz, welcome back!"

Remove-Variable -Force profile
set-location "C:\Users\moritz\builds"

Set-Variable psconfig "C:\Files\Active\ConfigFiles\PowerShell\profile.ps1"
Set-Variable vimconfig "C:\Users\Moritz\ConfigFiles\.vimrc"
Set-Variable vimfolder "C:\Users\Moritz\ConfigFiles\.vim"
Set-Variable bashconfig "C:\Users\Moritz\ConfigFiles\.bash_profile"

Set-Alias subl sublime_text
Set-Alias cleanlatex 'C:\Users\Moritz\ConfigFiles\PowerShell\cleanlatex.ps1'
Set-Variable cfg "C:\Users\Moritz\ConfigFiles"
Set-Variable in C:\Files\Inbox
Set-Variable ac C:\Files\Active
Set-Variable ar C:\Files\Archive
Set-Variable fi C:\Files
Set-Variable im C:\Files\Img
Set-Variable bu C:\Users\Moritz\builds 
Set-Variable PowerShell C:\Users\Moritz\ConfigFiles\PowerShell
