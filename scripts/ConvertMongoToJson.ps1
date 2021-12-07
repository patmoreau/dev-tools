function Base64ToGuid  
{  
    param($str);  
    $b = [System.Convert]::FromBase64String($str);
    [System.Array]::Reverse($b,0,4);
    [System.Array]::Reverse($b,4,2);
    [System.Array]::Reverse($b,6,2);

    $g = new-object -TypeName System.Guid -ArgumentList (,$b);
    return $g.ToString();
}

$mongoAccounts = Get-Content .\accounts.json
$mongoCashflows = Get-Content .\cashflows.json
$mongoCategories = Get-Content .\categories.json
$mongoTransactions = Get-Content .\transactions.json

Write-Host "src accounts: $($mongoAccounts.Length)"
Write-Host "src cashflows: $($mongoCashflows.Length)"
Write-Host "src categories: $($mongoCategories.Length)"
Write-Host "src transactions: $($mongoTransactions.Length)"

## load accounts
$accounts = @()
$hashAccounts = [ordered]@{}
foreach($line in $mongoAccounts) {
    $a = ConvertFrom-Json $line -AsHashtable
    $hashAccounts.Add(($a._id.'$oid'), (Base64ToGuid($a.globalId.'$binary'.base64)))
    $account = @{
        Id = Base64ToGuid($a.globalId.'$binary'.base64)
        Type = $a.type
        Name = $a.name
        Favorite = $a.favorite
        OpenBalance = [System.Decimal]::new($a.openBalance.'$numberDecimal')
        OpenDate = [System.DateTime]::Parse($a.openDate.'$date')
        Description = $a.description
        Inactive = $a.inactive
        UserId = Base64ToGuid($a.userId.'$binary'.base64)
    }
    $accounts += $account
}
$accounts | ConvertTo-Json | Out-File ./out/accounts.pure.json

## load categories
$categories = @()
$hashCategories = [ordered]@{}
foreach($line in $mongoCategories) {
    $a = ConvertFrom-Json $line -AsHashtable
    $hashCategories.Add(($a._id.'$oid'),(Base64ToGuid($a.globalId.'$binary'.base64)))
    $category = @{
        Id = Base64ToGuid($a.globalId.'$binary'.base64)
        Type = $a.type
        Name = $a.name
        Favorite = $a.favorite
        System = $a.system
        Color = $a.color
        BudgetAmount = [System.Decimal]::new($a.budgetAmount.'$numberDecimal')
        UserId = Base64ToGuid($a.userId.'$binary'.base64)
    }
    $categories += $category
}
$categories | ConvertTo-Json | Out-File ./out/categories.pure.json

## load cashflows
$cashflows = @()
$hashCashflows = [ordered]@{}
foreach($line in $mongoCashflows) {
    $a = ConvertFrom-Json $line -AsHashtable
    $hashCashflows.Add(($a._id.'$oid'),(Base64ToGuid($a.globalId.'$binary'.base64)))
    $cashflow = @{
        Id = Base64ToGuid($a.globalId.'$binary'.base64)
        EffectiveDate = [System.DateTime]::Parse($a.effectiveDate.'$date')
        IntervalType = $a.type
        Frequency = $a.frequency
        Recurrence = $a.recurrence
        Amount = [System.Decimal]::new($a.amount.'$numberDecimal')
        Description = $a.description
        Inactive = $a.inactive
        Tags = $a.tags
        UserId = Base64ToGuid($a.userId.'$binary'.base64)
        AccountId = $hashAccounts[$a.account.'$oid']
        CategoryId = $hashCategories[$a.category.'$oid']
    }
    $cashflows += $cashflow
}
$cashflows | ConvertTo-Json | Out-File ./out/cashflows.pure.json

## load transactions
$transactions = @()
foreach($line in $mongoTransactions) {
    $a = ConvertFrom-Json $line -AsHashtable
    $transaction = @{
        Id = Base64ToGuid($a.globalId.'$binary'.base64)
        Date = [System.DateTime]::Parse($a.date.'$date')
        Amount = [System.Decimal]::new($a.amount.'$numberDecimal')
        Description = $a.description
        Tags = $a.tags
        UserId = Base64ToGuid($a.userId.'$binary'.base64)
        AccountId = $hashAccounts[$a.account.'$oid']
        CategoryId = $hashCategories[$a.category.'$oid']
        CashflowId = $null
        CashflowDate = $null
    }
    if($null -ne $a.cashflow.'$oid') {
        $transaction.CashflowId = $hashCashflows[$a.cashflow.'$oid']
        $transaction.CashflowDate = [System.DateTime]::Parse($a.cashflowDate.'$date')
    }
    $transactions += $transaction
}
$transactions | ConvertTo-Json | Out-File ./out/transactions.pure.json

@{
    accounts=$accounts
    categories=$categories
    cashflows=$cashflows
    transactions=$transactions
} | ConvertTo-Json -Depth 3 | Out-File ./out/holefeederData.json

Write-Host "trg accounts: $($accounts.Count)"
Write-Host "trg cashflows: $($cashflows.Count)"
Write-Host "trg categories: $($categories.Count)"
Write-Host "trg transactions: $($transactions.Count)"

# valid UUID 02e86a83-f621-4563-80d2-b66b5206312a