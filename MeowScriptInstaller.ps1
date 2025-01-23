#Basic settings enabling and allowing clipboard history, showing hidden files and refreshing after its done running
# Allow AllowClipboardHistory
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name AllowClipboardHistory -Value 1
# Turn on clipboard history
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Clipboard' -Name EnableClipboardHistory -Value 1
# Show hidden files
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name Hidden -Value 1
# Refresh to take effect
$Shell = New-Object -ComObject Shell.Application
$Shell.Windows() | ForEach-Object { $_.Refresh() }

# Choco installs
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
wait-sleep 20
# Ensure community source
choco source add -n=chocolatey -s'https://chocolatey.org/api/v2/' --priority=1

#choco programs
$programs = @('obs-studio.install'
    'vcredist2017'
    'chocolatey'
    'chocolatey-compatibility.extension'
    'chocolatey-core.extension'
    'chocolatey-font-helpers.extension'
    'chocolatey-windowsupdate.extension'
    'GoogleChrome'
    'spotify'
    'discord'
    '7Zip'
    'vlc')

$programs.foreach{
    choco upgrade $_ -y
}

#prep winget
winget upgrade --id Microsoft.Winget.Source -e --source winget
winget source reset --force

# Install Winget programs
winget install --id=NZXT.CAM -e  ; winget install --id=MedalB.V.Medal -e  ; winget install --id=Nvidia.GeForceExperience -e

# Wait for all installations to finish
$installing = $true
while ($installing) {
    $chocoProcess = Get-Process -Name "choco" -ErrorAction SilentlyContinue
    $wingetProcess = Get-Process -Name "winget" -ErrorAction SilentlyContinue

    if (-not $chocoProcess -and -not $wingetProcess) {
        $installing = $false
    }
    else {
        Start-Sleep -Seconds 10
    }
}
# Import the necessary assemblies for creating a Windows Form
Add-Type -AssemblyName System.Windows.Forms

# Define the message you want to display
$message = @"
The following applications have been installed

Google Chrome
Spotify
Discord
NVIDIA GeForce Experience
Steam
7Zip
Medal
NZXT Cam
VLC

Unable to install:
Battle.net

All previously given applications have been installed.

made with <3 by Flow and Gio
"@

# Define the title of the message box
$title = "Installation Complete - Powered by MeowScript"

# Create a new Form to ensure the message box is on top
$form = New-Object Windows.Forms.Form
$form.TopMost = $true
$form.StartPosition = 'CenterScreen'

# Display the message box with the OK button
[System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
