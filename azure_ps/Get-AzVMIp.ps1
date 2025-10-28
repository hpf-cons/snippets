function Get-AzVMIp {
	Param (
		[Parameter(
			Mandatory=$true,
			ValueFromPipelineByPropertyName=$true,
			HelpMessage="The command to fire",
			Position=0
			)
		]
		[ValidateLength(3,63)]
		[string]
        [String]$VMName
	)
	$ErrorActionPreference = 'Stop'
	# explicit call to test the existence
	$myVm = Get-AzVM -VMName $VMName
	#$myVm | Select-Object Name,Location,ResourceGroupName,ProvisioningState | Out-Host
	if ( -not [String]::IsNullOrEmpty($myVm.OSProfile.LinuxConfiguration) ) {
		$myOS = 'Linux'
	} elseif ( -not [String]::IsNullOrEmpty($myVm.OSProfile.WindowsConfiguration) ) {
		$myOS = 'Windows'
	} else {
		$myOS = 'unknown'
	}
	# OsType,VmSize,Zone
	try {
		$myNotes = $myVm.Tags['Notes']
	} catch {
		$myNotes = ''
	}
	$myIfaces = @()
	foreach ($iface in $myVm.NetworkProfile.NetworkInterfaces) {
		$resIface = Get-AzNetworkInterface -ResourceId $iface.id
		$myIpConfs = $resIface.IpConfigurations | Select-Object PrivateIpAddress,PrivateIpAllocationMethod,Primary
		$myFqdn = $resIface.DnsSettings.InternalFqdn
		$myMac = $resIface.MacAddress
		$myDnsServers = $resIface.DnsSettings.DnsServers
		$myIfaces += [PSCustomObject] @{
			'ipConfigs' = $myIpConfs;
			'InternalFqdn' = $myFqdn;
			'DnsServers' = $myDnsServers;
			'MacAddress' = $myMac;
		}
	}
	$myResult = [PSCustomObject]@{
		'Name' = $myVm.Name;
		'Location' = $myVm.Location;
		'ResourceGroupName' = $myVm.ResourceGroupName;
		'ProvisioningState' = $myVm.ProvisioningState;
		'OSProfile' = $myOS;
		'Zones' = $myVm.Zones;
		'Interfaces' = $myIfaces;
	}
	$myResult | Select-Object Name,Location,ResourceGroupName,ProvisioningState,OSProfile,Zones | Format-List | Out-Host
	$myResult.Interfaces | Select-Object InternalFqdn,DnsServers,MacAddress | Format-List | Out-Host
	$myResult.Interfaces.ipConfigs | Format-List | Out-Host
}
