Set-ExecutionPolicy Unrestricted -force
Write-Host "scripting enabled"

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | where{$_.IPEnabled -eq “TRUE”} | select -first 1

Foreach($NIC in $NICs) {
$DNSServers = “192.168.0.199"
$NIC.SetDNSServerSearchOrder($DNSServers)
$NIC.SetDynamicDNSRegistration(“TRUE”)
$NIC.SetWINSServer(“192.168.0.199", "192.168.0.180")
}

Write-Host "DNS - 0.199"

Start-Sleep -s 5

$ProxyServer = "192.168.100.2"
$ProxyPort = "3128"
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$Proxy = $ProxyServer + ":" + $ProxyPort
Set-ItemProperty -Path $path -Name ProxyEnable -Value 1
Set-ItemProperty -Path $path -Name ProxyServer -Value $Proxy

Write-Host "Proxy - 192.168.100.2:3128"

Set-ExecutionPolicy Restricted -force
Write-Host "scripting disabled"

$domain = "domena.local"
$password = "password" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\addtodomain" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
Write-Host "PC added to domain.local"

Write-Host "Restart in 5s"
Start-Sleep -s 5
Restart-Computer -force