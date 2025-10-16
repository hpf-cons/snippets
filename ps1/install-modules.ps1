#!powershell

$ErrorActionPreference = 'Stop'

$myDLModules = @(
	'ThreadJob'
	'PSScriptAnalyzer'
	'Terminal-Icons'
)
$myOtherModules = @(
	'AzureHelpers'
	'ConsolutAzureHelpers'
	'FileSigningHelper'
)

foreach ($module in $myDLModules) {
	Write-Host "Installing ${module}:"
	Install-Module -Name $module -Scope 'CurrentUser'
}

# We could easily keep this up-to-date e.g. with chocolatey. But, alas, ... $long_rant .
Write-Host 'Installing oh-my-posh:'
# Since Micro$oft still make a lot of things too complicated with Microsoft store, you can
# only use this string when you want the "official" version from the store.
# (A proper software manager like Chocolatey would make this easier, but, alas, ... $long_rant.)
winget install 'XP8K0HKJFRXGCK'

Write-Host 'The following modules should be included in our backup:'
foreach ($module in $myOtherModules) {
	Write-Host "  - ${module}"
}
