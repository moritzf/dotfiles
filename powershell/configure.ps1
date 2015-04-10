
cmd /c mklink /h C:\Users\moritz\.gitignore_global C:\Users\moritz\ConfigFiles\git\global_gitignore.symlink
cmd /c mklink /h C:\Users\moritz\.gitconfig C:\Users\moritz\ConfigFiles\git\gitconfig.symlink

cmd /c mklink /h $profile C:\Users\moritz\ConfigFiles\powershell\profile.ps1

# Symlinks all config files to their corresponding files in Windows. Also configures some things
git config --global user.name "Moritz Finsterwalder"
git config --global user.email moritz.finsterwalder@gmail.com
git config --global core.excludesfile ~/.gitignore_global

cmd /c mklink /h $home\_vimrc $home\ConfigFiles\vim\vimrc.symlink
cmd /c mklink /j $home\vimfiles $home\ConfigFiles\vim\vim.symlink

mkdir C:\Temporary

cmd /c mklink /j $home\AppData\Roaming\"Sublime Text 3"\Packages\User C:\Users\Moritz\ConfigFiles\sublime\Windows\User
