try {
    $FAIKERS_PATH = "$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"
    New-Item -type directory -path "$FAIKERS_PATH" -Force | Out-Null
    $client = New-Object System.Net.WebClient
    $client.DownloadFile("https://github.com/Faikers/cli-releases/releases/latest/download/faikers-cli-x86_64-windows.zip", "$FAIKERS_PATH\faikers-cli.zip")
    Expand-Archive "$FAIKERS_PATH\faikers-cli.zip" "$FAIKERS_PATH" -Force
    Remove-Item "$FAIKERS_PATH\faikers-cli.zip"
    echo "The Faikers CLI is installed!"
} catch {
    echo "An error occurred during the installation process"
    exit 1
}
