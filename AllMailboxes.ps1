$From = "3/1/2021"
$To = "3/26/2021"

$intSent = 0
$intSentSize = 0
$intRec = 0
$intRecSize = 0
$Mailboxes = Get-Mailbox -ResultSize unlimited  | where {$_.RecipientTypeDetails -eq "UserMailbox"}

foreach ($Mailbox in $Mailboxes){
Get-TransportService | Get-MessageTrackingLog -Sender $Mailbox.PrimarySmtpAddress -ResultSize Unlimited -Start $From -End $To | ForEach {
    If ($_.EventId -eq "RECEIVE" -and $_.Source -eq "SMTP") {
        $intSent ++
        $intSentSize += $_.TotalBytes
    }
}

Get-TransportService | Get-MessageTrackingLog -Recipients $Mailbox.PrimarySmtpAddress -ResultSize Unlimited -Start $From -End $To | ForEach {
    If ($_.EventId -eq "DELIVER") {
        $intRec ++
        $intRecSize += $_.TotalBytes
    }
}
}
$intSentSize = $intSentSize/1MB
$intSentSize = '{0:n4}' -f $intSentSize
$intRecSize = $intRecSize/1MB
$intRecSize = '{0:n4}' -f $intRecSize

Write-Host "`nResult:`n--------------------`n"
Write-Host "Total Sent:"$intSent, ", Total Sent Size(MB):"($intSentSize)
Write-Host "Total Receive:"$intRec, ", Total Receive Size(MB):"($intRecSize)
Write-Host "`n--------------------`n"
