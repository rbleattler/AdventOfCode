# regex for matching any digit or verbal digit
$regex = [regex]"(?=(one|two|three|four|five|six|seven|eight|nine|\d))"

$data = Get-Content -Path $PSScriptRoot\input.txt
# $data = @(
# "two1nine",
# "eightwothree",
# "abcone2threexyz",
# "xtwone3four",
# "4nineeightseven2",
# "zoneight234",
# "7pqrstsixteen"
# )

function Get-Numeral {
  param([string]$i)
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
    default {
      Write-Warning "$PSItem is not a valid numeral"
      throw "NaN"
    }
  }
}

$allValues = $data | ForEach-Object {
  $string = $PSItem
  $regexMatches = $regex.Matches($string).foreach({$PSItem.Groups[1].Value})
  $first = Get-Numeral $($regexMatches[0])
  $last = Get-Numeral $($regexMatches[-1])
  # this is unnecessary, I create an object so I can look at the outputs and assess the results for troubleshooting
  $total = '{0}{1}' -f $first, $last
  $record = [PSCustomObject]@{
    First  = $first
    Last   = $last
    String = $string
    Count  = $regexMatches.Count
    Total  = $total
  }
  $record
  Remove-Variable -Name first, last, string, regexMatches, total, record
}

$sum = ($allValues.Total | Measure-Object -Sum).Sum
$sum |clip
Write-Host "The sum of all calibration values has been copied to your clipboard, the value is: " -NoNewline
Write-Host "$sum" -ForegroundColor Green -BackgroundColor Black
Write-Host "To access the data, run `$allValues|Out-GridView"