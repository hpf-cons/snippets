#!powershell
# vim:syntax=ps1:ts=4
#requires -version 5
function Set-AzureSignedSSHKey {
	<#
	.SYNOPSIS
	Create an Azure-signed SSH key for usage with aadsshlogin on target
	machines, and with any _sophisticated_ SSH client on the user's machine(s).

	.DESCRIPTION
		This function helps users in creating their Azure-signed RSA certificate.
		This is using an existing RSA key combination and creating a short-lived
		AzureAD certificate based on this, enabling the user to login with Entra
		users through aadsshconfig for systems where a sophisticated configuration
		management (including rights and roles) is not in-place.
		Files:
		- $env:USERPROFILE\.ssh/id_rsa_azure: your original RSA key
		- $env:USERPROFILE\.ssh/id_rsa_azure_orig.pub: the accompanying public key
		- $env:USERPROFILE\.ssh/id_rsa_azure.pub: the signed result (some clients expect this
										name to be the public cert)

	.EXAMPLE
	Set-AzureSignedSSHKey

	.INPUTS
	$env:USERPROFILE/.ssh/id_rsa_azure_orig.pub: Your previously generated public key
	$env:USERPROFILE/.ssh/id_rsa_azure: Your previously generated private key (not altered or actually used here)

	.OUTPUTS
	$env:USERPROFILE/.ssh/id_rsa_azure.pub: the signed public key

	.NOTES
	TODO:
	1. Find out whether we can make certificates live longer than 1 hour. The AzureCLI GitHub
	   issue has been ignored for four years already, however (as of 2025).
	   (https://github.com/Azure/azure-cli-extensions/issues/3565)
	   A solution may be proper configmanagement and skipping aadsshlogin altogether,
	   accounts still being validated through Azure AD ("Entra") anyways.
	
	REMARKS:
	1. We are using "id_rsa_azure.pub" as public key file to "id_rsa_azure" - this way
	   a standard SSH client can correctly derive the public key file name from the private key one.

	EVALUATED:
	1. Unlike az ssh vm, az ssh cert triggers the re-login web ui window in case of an expired
	   token. Nothing to be done here.
	2. The Azure-signed certificate is valid for any subscription, so we do not need a subscription
	   selection either.
	#>
	[Alias(
		'Sign-AzureSSHKey',
		'azsignsshkey'
	)]
	# PowerShell again :-> We need to define parameters here, even if empty, otherwise
	# PowerShell bugs out on the Alias definitions above. ¯\_ (ツ)_/¯ 
	Param ()
	Write-Host "Trying to locate SSH key files..."
	if ( -not (Test-Path "${env:USERPROFILE}\.ssh/id_rsa_azure") ) {
		throw [System.IO.FileNotFoundException]::New("File ${env:USERPROFILE}\.ssh/id_rsa_azure not found, create a private key first.")
	}
	if ( -not (Test-Path "${env:USERPROFILE}\.ssh/id_rsa_azure_orig.pub") ) {
		throw [System.IO.FileNotFoundException]::New("File ${env:USERPROFILE}\.ssh/id_rsa_azure_orig.pub not found, deploy your public certificate to this file.")
	}
	Write-Host "Checking if AzureCLI is installed..."
	try {
		az login --help > $null
	}
	catch [System.Management.Automation.CommandNotFoundException] {
		throw [System.Management.Automation.CommandNotFoundException]::New('"az" command not found, install Azure CLI first.')
	}
	Write-Host "Checking if AzureCLI SSH extension is installed..."
	if ( -not ((az version -o json | ConvertFrom-Json).extensions.PSobject.Properties.name -like "ssh") ) {
		throw [System.TypeLoadException]::New('AzureCLI SSH extension cannot be found, please install it first.')
	}
	az ssh cert --file "${env:USERPROFILE}\.ssh/id_rsa_azure.pub" -p "${env:USERPROFILE}\.ssh/id_rsa_azure_orig.pub"
	
	Write-Host "Use following files with your PuTTY/Linux ssh/...:"
	Write-Host "1. ${env:USERPROFILE}\.ssh/id_rsa_azure.pub: public key (needs to be set e.g. in PuTTY)"
	Write-Host "2. ${env:USERPROFILE}\.ssh/id_rsa_azure: private key"
}
