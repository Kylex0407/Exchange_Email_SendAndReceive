$From = "6/1/2019"
$To = "6/14/2019"

$intSent = 0
$intSentSize = 0
$intRec = 0
$intRecSize = 0
$Mailbox = "administrator@domain.com"

Get-TransportService | Get-MessageTrackingLog -Sender $Mailbox -ResultSize Unlimited -Start $From -End $To | ForEach {
    If ($_.EventId -eq "RECEIVE" -and $_.Source -eq "SMTP") {
        $intSent ++
        $intSentSize += $_.TotalBytes
    }
}

Get-TransportService | Get-MessageTrackingLog -Recipients $Mailbox -ResultSize Unlimited -Start $From -End $To | ForEach {
    If ($_.EventId -eq "DELIVER") {
        $intRec ++
        $intRecSize += $_.TotalBytes
    }
}
$intSentSize = $intSentSize/1MB
$intSentSize = '{0:n4}' -f $intSentSize
$intRecSize = $intRecSize/1MB
$intRecSize = '{0:n4}' -f $intRecSize

Write-Host "`nResult:`n--------------------`n"
Write-Host "This Mailbox Total Sent:"$intSent, ", Total Sent Size(MB):"($intSentSize)
Write-Host "This Mailbox Total Receive:"$intRec, ", Total Receive Size(MB):"($intRecSize)
Write-Host "`n--------------------`n"
