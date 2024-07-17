$config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-Json

$localFolderPath = $config.localFolderPath
$user = $config.user
$logFile = "$PSScriptRoot\upload_to_gcs.log"

function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logMessage
}

if (-not (Get-Command "gsutil" -ErrorAction SilentlyContinue)) {
    Write-Log "gsutil is not installed. Please install Google Cloud SDK."
    exit 1
}

$destinationPath = "gs://backup-$user/"
$output = gsutil -m cp -r $localFolderPath $destinationPath 2>&1
$output | ForEach-Object { Write-Log $_ }