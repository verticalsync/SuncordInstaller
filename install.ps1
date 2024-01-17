$DOWNLOAD_CLI = "https://github.com/verticalsync/SuncordInstaller/releases/latest/download/SuncordInstallerCli.exe"
$DOWNLOAD_GUI = "https://github.com/verticalsync/SuncordInstaller/releases/latest/download/SuncordInstaller.exe"

if ([Environment]::Is64BitOperatingSystem -and [System.Environment]::OSVersion.Version.Major -ge 10) {
	Write-Output "=============================="
	Write-Output "|      Suncord Installer     |"
	Write-Output "=============================="
	Write-Output ""
	Write-Output "Which installer version do you want to use?"
	Write-Output "1) Graphical - More user friendly but may not work on old/low-end GPUs"
	Write-Output "2) Terminal - Choose this option if the graphical installer does not work"
	Write-Output "Q) Quit without doing anything"
	Write-Output ""
	$choice = Read-Host "Please choose by typing a number or Q"
} else {
	$choice = 2
}

switch ($choice) {
	1 { $link = $DOWNLOAD_GUI }
	2 { $link = $DOWNLOAD_CLI }
	q { Return }
	default {
		Write-Output "Invalid choice $choice. Exiting..."
		Return
	}	
}

$outfile = "$env:TEMP\$(([uri]$link).Segments[-1])"

Write-Output "Downloading installer to $outfile"

Invoke-WebRequest -Uri "$link" -OutFile "$outfile"

Write-Output ""

if ($choice -eq 2) {
	Write-Output "What do you want to do?"
	Write-Output "1) Install Suncord"
	Write-Output "2) Install OpenAsar"
	Write-Output "3) Uninstall Suncord"
	Write-Output "4) Uninstall OpenAsar"
	Write-Output "5) Reinstall & Update Suncord"
	Write-Output "Q) Quit without doing anything"
	Write-Output ""
	$choice = Read-Host "Please choose by typing a number or Q"

	switch ($choice) {
		1 { $flag = "-install" }
		2 { $flag = "-install-openasar" }
		3 { $flag = "-uninstall" }
		4 { $flag = "-uninstall-openasar" }
		5 { $flag = "-reinstall" }
		q { Return }
		default {
			Write-Output "Invalid choice $choice. Exiting..."
			Return
		}
	}

	Start-Process -Wait -NoNewWindow -FilePath "$outfile" -ArgumentList "$flag" 
} else {
	Start-Process -Wait -NoNewWindow -FilePath "$outfile"
}


# Cleanup
Remove-Item -Force "$outfile"
