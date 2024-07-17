$config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-Json

$localFolderPath = $config.localFolderPath
$user = $config.user
$logFile = "$PSScriptRoot\upload_to_gcs.log"
$zipFilePath = "$PSScriptRoot\backup.zip"
$zipFolderPath = "$PSScriptRoot\backup_folder"

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

if (-not (Test-Path $zipFolderPath)) {
    New-Item -ItemType Directory -Path $zipFolderPath
}

$zipFileFullPath = Join-Path -Path $zipFolderPath -ChildPath "backup.zip"
if (Test-Path $zipFileFullPath) {
    Remove-Item $zipFileFullPath
}

Add-Type -AssemblyName "System.IO.Compression.FileSystem"
[System.IO.Compression.ZipFile]::CreateFromDirectory($localFolderPath, $zipFileFullPath)

if (-not (Test-Path $zipFileFullPath)) {
    Write-Log "Failed to create ZIP file."
    exit 1
}

$todayDate = (Get-Date).ToString("yyyy-MM-dd")

$destinationPath = "gs://backup-$user/$todayDate/"
$output = gsutil -m rsync -r $zipFolderPath $destinationPath 2>&1
$output | ForEach-Object { Write-Log $_ }

Remove-Item $zipFileFullPath
Remove-Item $zipFolderPath -Recurse
