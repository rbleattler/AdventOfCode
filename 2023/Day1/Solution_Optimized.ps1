$regex = [regex]"(?=(one|two|three|four|five|six|seven|eight|nine|\d))"
$data = Get-Content -Path $PSScriptRoot\input.txt
function Get-Numeral([string]$i) {
  switch ($i) {
    { $_ -in @("zero", "0") } { 0 }
    { $_ -in @("one", "1") } { 1 }
    { $_ -in @("two", "2") } { 2 }
    { $_ -in @("three", "3") } { 3 }
    { $_ -in @("four", "4") } { 4 }
    { $_ -in @("five", "5") } { 5 }
    { $_ -in @("six", "6") } { 6 }
    { $_ -in @("seven", "7") } { 7 }
    { $_ -in @("eight", "8") } { 8 }
    { $_ -in @("nine", "9") } { 9 }
    default { throw "NaN" }
  }
}

$data.ForEach{ $rm = $regex.Matches($_).foreach({ $PSItem.Groups[1].Value }); '{0}{1}' -f (Get-Numeral $($rm[0])), (Get-Numeral $($rm[-1])) } | Measure-Object -Sum | Select-Object -ExpandProperty Sum