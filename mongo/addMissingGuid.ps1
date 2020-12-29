@('accounts', 'cashflows', 'categories', 'objectsData', 'transactions') |
ForEach-Object { 
(Get-Content -Path ".\$_.json") | 
Foreach-Object {$_ -replace '"guid":null',"""guid"":""$([guid]::NewGuid().ToString().ToLowerInvariant())"""} |
Out-File -Path ".\$_.fixed.json"
}
