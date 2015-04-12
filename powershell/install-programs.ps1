#########################
# Autoinstall script using chocolatey
#########################
# Note: Net 4.0 must be installed prior to running this script
#
#Modify this line to change packages
$items = @("google-chrome-x64", "vlc", "javaruntime", "DotNet4.5", "7zip.install", "python", "notepadplusplus.install", "git.install", "androidstudio", "sharpkeys" )
 
 
 
#################
# Create packages.config based on passed arguments
#################
$xml = '<?xml version="1.0" encoding="utf-8"?>'+ "`n" +'<packages>' + "`n"
foreach ($item in $items)
{
  $xml += "`t" +'<package id="' + $item + '"/>' + "`n"
}
$xml += '</packages>'
 
$file = ([system.environment]::getenvironmentvariable("userprofile") + "\packages.config")
$xml | out-File $file
 
######
# Install packages with cinst
######
 
cinst $file --yes
 
 
########
# Delete packages.config
Remove-Item $file
