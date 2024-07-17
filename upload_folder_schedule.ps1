$config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-Json
$scriptPath = "$PSScriptRoot\upload_folder.ps1"
$logPath = "$PSScriptRoot\upload_to_gcs.log"
$userForAction = "$env:USERDOMAIN\$env:USERNAME"
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File `"$scriptPath`" *> `"$logPath`" 2>&1"

$time = "{0:D2}:{1:D2}" -f $config.hour, $config.minute
$trigger = New-ScheduledTaskTrigger -Daily -At $time

$principal = New-ScheduledTaskPrincipal -UserId $userForAction -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskName "UploadToGCSDaily" -Description "Uploads folder to GCS daily at specified time"
