# POWERSHELL SCRIPT - START
######################################################

# TODO: Different gateways for different NICs
# In this project, we assume we have only one network
# interface, though.

######################################################

$IPType         = "IPv4"
$DefaultGateway = "10.10.1.1"
$DefaultDNSAddr = "10.10.1.1"
$MaskBits       = "24"

######################################################
# Set static IP for this computer
# For each network interface...

function setStaticNIC($DefaultDNSAddr, $MaskBits, $DefaultGateway, $IPType) {

  $NICadapters = Get-WmiObject -Class win32_networkadapter -Filter "netconnectionstatus = 2"

  foreach ($adapter in $NICadapters) {

    # Retrieve the network adapter to configure
    $adapterName = $adapter | Select -Property Name -ExpandProperty Name
    $adapterConf = $adapter | Get-NetIPConfiguration
    $adapterIndex = $adapterConf | Select -ExpandProperty InterfaceIndex

    # Get current IPv4 address for static IPv4 configuration
    $curIPv4 = $adapterConf | Select -ExpandProperty IPv4Address | Select -ExpandProperty IPAddress
    $newIPv4 = [String]$curIPv4

    # Skip this loop round if IPv4 is not pre-defined for this NIC
    if (!$curIPv4) {
      Write-Host "Network interfaces: No existing IPv4 address on $adapterName. Skipping this NIC"
      continue
    } else {

      # Get current NIC gateway
      $curGateway = $adapter | Get-NetIPConfiguration | `
      Select -ExpandProperty IPv4DefaultGateway | `
      Select -ExpandProperty NextHop

      # We must have gateway for static network addressing
      if (!$DefaultGateway) {
        $DefaultGateway = $curGateway
        # Remove any existing gateway from the IPv4 adapter
        Remove-NetRoute -InterfaceIndex $adapterIndex -Confirm:$False -ErrorAction SilentlyContinue
      }

      Write-Host "`nSetting current IPv4 to static:`n`tNIC:`t`t" `
      $adapterName "`n`tIPv4/mask:`t" ($curIPv4 + "/" + $MaskBits) "`n`tDNS servers:`t" `
      $DefaultDNSAddr
      Write-Host "`tGateway:`t" $DefaultGateway
      Write-Host "`n"

      # Remove any existing IPv4 address from the IPv4 adapter
      if ($curIPv4) {
        Remove-NetIPAddress -InterfaceIndex $adapterIndex -Confirm:$False
      }

      # Configure new IP address
      $adapterConf | New-NetIPAddress `
      -AddressFamily $IPType `
      -IPAddress $newIPv4 `
      -PrefixLength $MaskBits `
      -DefaultGateway $DefaultGateway `
      2>&1 > $null

      # Configure DNS addresses for this NIC
      $adapterConf | Set-DnsClientServerAddress `
      -ServerAddresses $DefaultDNSAddr

    }
  }
}

######################################################

setStaticNIC `
-DefaultDNSAddr $DefaultDNSAddr`
-MaskBits $MaskBits`
-DefaultGateway $DefaultGateway`
-IPType $IPType

######################################################
# POWERSHELL SCRIPT - END
