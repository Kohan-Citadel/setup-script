@echo off
Rem Make powershell read this file, skip a number of lines, and execute it.
Rem This works around .ps1 bad file association as non executables.
Rem Technique from https://stackoverflow.com/a/65314841
PowerShell -Command "Get-Content '%~dpnx0' | Select-Object -Skip 6 | Out-String | Invoke-Expression"
goto :eof
#!/usr/bin/env pwsh

##KSETUP.PS1
# This is a little PowerShell script to install the required things
# to get Kohan up and running, as well as removing any older fixes
# that are no longer needed

function Get-LatestTag {
    param (
        [string]$UserRepo
    )
    $target = "https://api.github.com/repos/$UserRepo/releases/latest"
    $tag = (Invoke-WebRequest -UseBasicParsing $target | ConvertFrom-Json).tag_name
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
$launcherTarget = 'https://github.com/Kohan-Citadel/kohangold-KG-/releases/download/v0.9.6/KohanLauncher.exe'
$khaldunNetTarget = 'Kohan-Citadel/khaldun.net-client'
$cncddrawTarget = 'FunkyFr3sh/cnc-ddraw'

$kgLatest = Get-LatestTag $kgTarget

# Substring strips the leading v which is not used in the filename
$kgFilename = "KohanGold-$($kgLatest.Substring(1)).tgx"
$openspyFilename = 'dinput.zip'
$cncddrawFilename = 'cnc-ddraw.zip'

$cwd = Split-Path -Path (Get-Location) -Leaf

if (Test-Path '_ag.exe') {
    # Remove the files listed in $rmtargets
    foreach ($target in $rmtargets) {
        if (Test-Path $target) {
            Write-Output "Removing $target"
            Remove-Item -Force $target
        }
    }
    try {
        # Download Kohan Gold
        if (-Not (Test-Path "$kgFilename")) {
            $target = "https://github.com/$kgTarget/releases/download/$kgLatest/$kgFilename"
            Write-Output "Downloading KohanGold $kgLatest from $target"
            Invoke-WebRequest -UseBasicParsing -OutFile $kgFilename $target
        }

        # Download KohanLauncher.exe
        if (-Not (Test-Path 'KohanLauncher.exe')) {
            Write-Output "Downloading KohanLauncher"
            Invoke-WebRequest -UseBasicParsing -OutFile "KohanLauncher.exe" $launcherTarget
        }

        # Download OpenSpy Client
        $tag = Get-LatestTag $khaldunNetTarget
        $target = "https://github.com/$khaldunNetTarget/releases/download/$tag/$openspyFilename"
        Write-Output "Downloading khaldun.net client $tag from $target"
        Invoke-WebRequest -UseBasicParsing -OutFile $openspyFilename $target
        # Unzip OpenSpy Client
        Write-Output "Unpacking khaldun.net Client $tag"
        Expand-Archive -Force $openspyFilename
        Move-Item -Force -Destination dinput.dll "dinput/dinput.dll"
        Write-Output "Cleaning up khaldun.net files"
        Remove-Item -Recurse "dinput/"
        Remove-Item $openspyFilename

        # Download cnc-ddraw
        $tag = Get-LatestTag $cncddrawTarget
        $target = "https://github.com/$cncddrawTarget/releases/download/$tag/$cncddrawFilename"
        Write-Output "Downloading cnc-ddraw $tag from $target"
        Invoke-WebRequest -UseBasicParsing -OutFile $cncddrawFilename $target
        # Unzip cnc-ddraw
        Write-Output "Unpacking cnc-ddraw $tag"
        Expand-Archive -Force $cncddrawFilename
        foreach ($item in (Get-Childitem "cnc-ddraw")) {
            Move-Item -Force -Destination './' $item.fullname
        }
        Write-Output "Cleaning up cnc-ddraw files"
        Remove-Item -Recurse "cnc-ddraw"
        Remove-Item $cncddrawFilename
        # Set cnc-ddraw default options
        $kag_section = @"
; Kohan: Ahriman's Gift
[_ag]
windowed=true
fullscreen=true
maintas=true
"@
        Add-Content './ddraw.ini' $kag_section

        $choice = Read-Host -Prompt "Open cnc-ddraw config tool? [y|N]"
        if ( $choice -eq "y" ) {
            & "./cnc-ddraw config.exe"
        }
    }
    catch {
        $_
    }
	
} else {
    Write-Output "Please run this from within the install directory for Kohan: Ahriman's Gift"
	Write-Output "For the Steam version, this should be 'C:\Program Files (x86)\Steam\steamapps\common\Kohan Ahrimans Gift'"
	Read-Host -Prompt "Press ENTER to exit"
}
