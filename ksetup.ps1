#!pwsh

##KSETUP.PS1
# This is a little PowerShell script to install the required things
# to get Kohan up and running, as well as removing any older fixes
# that are no longer needed

function Get-LatestTag {
    param (
        [string]$UserRepo
    )
    $target = "https://api.github.com/repos/$UserRepo/releases"
    $tag = (Invoke-WebRequest $target | ConvertFrom-Json)[0].tag_name
    Write-Output $tag
}

$rmtargets = @(
    'D3D8.dll',
    'D3D9.dll',
    'D3DImm.dll',
    'DDraw.dll',
    'dgVoodoo.conf',
    'dgVoodooCpl.exe',
    'libwine.dll',
    'wine3d.dll'
)

$kgTarget = 'Kohan-Citadel/kohangold-KG-'
$openspyTarget = 'anzz1/openspy-client'
$cncddrawTarget = 'FunkyFr3sh/cnc-ddraw'

#Switch this back after 0.9.7 releases
#Doesn't handle prerelease versions
#$kgLatest = Get-LatestTag $kgTarget
$kgLatest = 'v0.9.6'

# Substring strips the leading v which is not used in the filename
$kgFilename = "KohanGold-$($kgLatest.Substring(1)).tgx"
$openspyFilename = 'openspy.zip'
$cncddrawFilename = 'cnc-ddraw.zip'

$cwd = Split-Path -Path (Get-Location) -Leaf

if ( $cwd -ceq 'Kohan Ahrimans Gift') {
    # Remove the files listed in $rmtargets
    foreach ($target in $rmtargets) {
        if (Test-Path $target) {
            Write-Output "Removing $target"
            Remove-Item -Force $target
        }
    }
    try {
        # Download Kohan Gold
        $target = "https://github.com/$kgTarget/releases/download/$kgLatest/$kgFilename"
        Write-Output "Downloading KohanGold $kgLatest from $target"
        Invoke-WebRequest -OutFile $kgFilename $target

        # Download OpenSpy Client
        $tag = Get-LatestTag $openspyTarget
        $target = "https://github.com/$openspyTarget/releases/download/$tag/$openspyFilename"
        Write-Output "Downloading OpenSpy Client $tag from $target"
        Invoke-WebRequest -OutFile $openspyFilename $target
        # Unzip OpenSpy Client
        Write-Output "Unpacking OpenSpy Client $tag"
        Expand-Archive -Force $openspyFilename
        Move-Item -Force -Destination dinput.dll "openspy/openspy.x86.dll"
        Remove-Item -Recurse "openspy/"
        Remove-Item $openspyFilename

        # Download cnc-ddraw
        $tag = Get-LatestTag $cncddrawTarget
        $target = "https://github.com/$cncddrawTarget/releases/download/$tag/$cncddrawFilename"
        Write-Output "Downloading cnc-ddraw $tag from $target"
        Invoke-WebRequest -OutFile $cncddrawFilename $target
        # Unzip cnc-ddraw
        Write-Output "Unpacking cnc-ddraw $tag"
        Expand-Archive -Force $cncddrawFilename
        foreach ($item in (Get-Childitem "cnc-ddraw")) {
            Move-Item -Force -Destination './' $item.fullname
        }
        Remove-Item -Recurse "cnc-ddraw"
        Remove-Item $cncddrawFilename
        # Set cnc-ddraw default options
        (get-content './ddraw.ini').Replace('windowed=false','windowed=true').Replace('fullscreen=false','fullscreen=true').Replace('maintas=false','maintas=true') | Set-Content './ddraw.ini'
        $choice = Read-Host -Prompt "Open cnc-ddraw config tool? [y|N]"
        if ( $choice -eq "y" ) {
            & "./cnc-ddraw config.exe"
        }
    }
    catch [System.Net.Http.HttpRequestException] {
        Write-Output "Download failed: $_"
    }
    catch {
        $_
    }
	
} else {
    Write-Output "Please run this from within the install directory for Kohan: Ahriman's Gift"
}
