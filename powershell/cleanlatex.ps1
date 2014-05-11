get-childitem c:\Files -include *.synctex.gz -recurse | foreach ($_) {remove-item $_.fullname}
get-childitem c:\Files -include Output -recurse | foreach ($_) {remove-item $_.fullname}