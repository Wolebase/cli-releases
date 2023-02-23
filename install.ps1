try {
    $WOLEBASE_PATH = "$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"
    New-Item -type directory -path "$WOLEBASE_PATH" -Force | Out-Null
    $client = New-Object System.Net.WebClient
    $client.DownloadFile("https://github.com/Wolebase/cli-releases/releases/latest/download/wolebase-cli-x86_64-windows.zip", "$WOLEBASE_PATH\wolebase-cli.zip")
    Expand-Archive "$WOLEBASE_PATH\wolebase-cli.zip" "$WOLEBASE_PATH" -Force
    Remove-Item "$WOLEBASE_PATH\wolebase-cli.zip"
    echo "The Wolebase CLI is installed!"
} catch {
    echo "An error occurred during the installation process"
    exit 1
}
