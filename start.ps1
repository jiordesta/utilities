# ============================================
# Reliable persistent Git Bash launcher
# ============================================

$parentFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

$gitbash = "C:\Program Files\Git\git-bash.exe"

$folders = Get-ChildItem -Path $parentFolder -Directory

foreach ($folder in $folders) {

    $folderPath = $folder.FullName

    $tempScript = Join-Path $env:TEMP "$($folder.Name)-install.sh"

    @"
cd "$folderPath"
npm run autorun

echo
echo "Press Enter to close..."
read
"@ | Set-Content $tempScript

    Start-Process $gitbash -ArgumentList $tempScript
}