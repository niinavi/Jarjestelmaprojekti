# POWERSHELL - START

# TODO
# Salt minion installer
# - Installer parameters not given
# - Installer command not tested

# Salt minion configuration file
# - Path & filename missing
# - Configuration not tested

# Salt minion: restart after configuration changes
# Salt minion: get proper service name to enable automatic service start-up

######################################################

# NOTE: This Salt minion version MUST match with the Salt Master version!

$minion_fileURL     = "https://repo.saltstack.com/windows/Salt-Minion-2018.3.3-Py3-AMD64-Setup.exe"
$minion_prettyName  = "SaltStack minion installer (Windows)"
$minion_description = "Central management client program"

$minion_dlDestPath  = "$env:SystemDrive\salt_minion_setup"
$minion_dlDestFile  = ($minion_dlDestPath + "\Salt-Minion-2018.3.3-Py3-AMD64-Setup.exe")

$minion_confFile    = ""

$saltmaster_IPv4    = "10.10.1.2"
$minion_id          = (Get-WmiObject -Class Win32_ComputerSystem | Select -ExpandProperty Name)


######################################################
# Test internet connection

function testInternet($hostDNS) {
  Write-Host "Testing internet connectivity to $hostDNS"
  if ((Resolve-DNSName $hostDNS -DnsOnly -DnsSecOk -ErrorAction SilentlyContinue) -eq $null) {
    "`nCan't connect to internet. Please check your internet connection and try again."
    exit 1
  }
}

######################################################
# Download Salt minion installer

testInternet -hostDNS "repo.saltstack.com"
Import-Module BitsTransfer

function downloadFile($dlPrettyName, $dlDescription, $dlURLSrc, $dlDestPath, $dlDestFile) {

  if (-Not (Test-Path -Path $dlDestPath)) {
    New-Item -ItemType Directory -Path $dlDestPath > $null
  }

  if (-Not (Test-Path -Path $dlDestFile)) {
    Write-Host "Downloading $dlPrettyName (saving to: $dlDestPath)"
    Start-BitsTransfer `
    -Source $dlURLSrc `
    -Destination $dlDestFile `
    -DisplayName $dlPrettyName `
    -Description $dlDescription `
    -TransferType Download
    # TODO Error functionality
  }
}

###########################

downloadFile `
-dlPrettyName $minion_prettyName `
-dlDescription $minion_description `
-dlURLSrc $minion_fileURL `
-dlDestPath $minion_dlDestPath `
-dlDestFile $minion_dlDestFile

######################################################
# Run Salt minion installer

Invoke-Command -ScriptBlock {
  try { cmd.exe /C $minion_dlDestFile }
  catch { return $_ }
}

######################################################
# Set Salt minion configuration

Write-Host "Salt Minion: configuring settings"

if (-Not (Test-Path $minion_confFile)) {
  New-Item -ItemType File $minion_confFile
}

Set-Content -Path $minion_confFile -Value @"
master: $saltmaster_IPv4
id: $minion_id
"@

######################################################
# Restart Salt minion

Write-Host "Salt Minion: restarting minion service"

# Set Salt minion auto-start during system boot-up

Write-Host "Salt Minion: setting automatic start-up for minion service"
Set-Service <MINION_SERVICE> -StartupType Automatic -Status Running -Confirm:$False

######################################################
# POWERSHELL - END