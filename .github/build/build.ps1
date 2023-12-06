$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

### Prepare NuGet / PSGallery
if (!(Get-PackageProvider | Where-Object { $_.Name -eq 'NuGet' })) {
    Write-Verbose "Installing NuGet" -Verbose
    Install-PackageProvider -Name NuGet -force | Out-Null
}
Write-Verbose "Preparing PSGallery repository" -Verbose
Import-PackageProvider -Name NuGet -force | Out-Null
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}
Write-Verbose ""
Update-ModuleManifest -Path ".\MyTestSOAModule\MyTestSOAModule.psd1" -ModuleVersion ($env:MODULE_VER).TrimStart("v")
Write-Host ${{ github.event.pull_request.head.ref }}
git branch --show-current