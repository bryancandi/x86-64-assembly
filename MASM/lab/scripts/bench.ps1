$sw = [System.Diagnostics.Stopwatch]::StartNew()

$runs = 100
$seqs = 370

for ($i = 1; $i -le $runs; $i++) {
    $seqs | ..\fibonacci256.exe > $null
}

$sw.Stop()

Write-Host "Runs: $runs"
Write-Host "Total ms:" $sw.ElapsedMilliseconds
