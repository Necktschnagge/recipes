pdflatex.exe -synctex=1 -interaction=nonstopmode book.tex > custom_log.log
Get-Content custom_log.log
Get-Content custom_log.log | findstr /r "at( )*line[s]*[0-9]*" > custom_errors.log
if ((Get-Content custom_errors.log).length -ne 0){
	Write-Error "There were errors when compiling with latex!"
	Get-Content custom_errors.log
	exit 1;
	} else {
	Write-Output "No errors or warnings found by regex."
	}
