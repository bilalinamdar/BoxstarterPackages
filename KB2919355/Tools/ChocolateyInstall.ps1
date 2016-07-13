$kb = "KB2919355"
$packageName = "KB2919355"
$installerType = "msu"
$silentArgs = "/quiet /norestart /log:`"$env:TEMP\$kb.Install.log`""

# Get-CimInstance only available on Powershell v3+ which is shipped since Windows 8 & Windows Server 2012
$os = Get-CimInstance Win32_OperatingSystem -ea SilentlyContinue 
$version = [Version]$os.Version

if ($version -eq $null -or $version -lt [Version]'6.3' -or $version -ge [Version]'6.4') {
	Write-Host "Skipping installation because this hotfix only applies to Windows 8.1 and Windows Server 2012 R2."
	return
}

if (Get-HotFix -id $kb -ea SilentlyContinue)
{
	Write-Host "Skipping installation because hotfix $kb is already installed."
	return
}

if ($os.ProductType -eq '1') {
	# Windows 8.1
	$url = "http://download.microsoft.com/download/4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2919355-x86.msu"
	$url64 = "http://download.microsoft.com/download/D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2919355-x64.msu"
} else {
	# Windows Server 2012 R2
	$url64 = "http://download.microsoft.com/download/2/5/6/256CCCFB-5341-4A8D-A277-8A81B21A1E35/Windows8.1-KB2919355-x64.msu"
}

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes @(0, 3010)

if (!(Get-HotFix -id $kb -ea SilentlyContinue)) {
	throw "Hotfix still not found after installation was completed!"
}
