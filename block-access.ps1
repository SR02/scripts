#Parameters for the script
param (
    [string]$username = $(throw "-username is required.")
)
#Setup Logging
if ([System.Diagnostics.EventLog]::SourceExists("Block-Access") -eq $false){
    New-Eventlog -LogName Application -Source "Block-Access"
}
$shares = Get-SmbShare |where {$_.name.endswith("$") -ne $_}
#Loop for each share on the server and remove the users access
Write-EventLog -LogName Application -Source "Block-Access" -entryType Information -EventID 1337 -Message "User infected!!! Removing Acess for User: $username from all shares"
foreach ($share in $shares) {
Block-SmbShareAccess -name $share.name -AccountName $username -force
}