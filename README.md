# Exchange_Email_SendAndReceive
Those scripts are based on Message Tracking Log. Before using those scripts, you need to check the Message Tracking is enabled and the maximum age for the message tracking log files: The default is 30 days

```
Get-TransportService | select Name,MessageTrackingLogMaxAge,MessageTrackingLogEnabled
```
