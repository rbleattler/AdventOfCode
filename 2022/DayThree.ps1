using namespace System.Collections.Generic;
using namespace System.Linq;
# Get data from d3data.txt
Set-Location $PSScriptRoot
$Data = Get-Content $pwd\res\DayThreeData.txt

# Create a hashtable containing the following sets of letter to number pairs
# a-z = 1-26
# A-Z = 27-52

$Alpha = [System.Collections.Generic.List[PSCustomObject]]::new()
$lowerRange = 1..26
$lowerChar = ([char]'a'..[char]'z')
$upperRange = 27..52
$upperChar = ([char]'A'..[char]'Z')

$lowerRange.ForEach({
    #Write-Debug "Adding $($PSItem) to hashtable"
    $pair = [pscustomobject]@{
      $lowerChar[($PSItem - 1)] = $PSItem
    }
    $Alpha.Add($pair)
  })
$upperRange.ForEach({
    #Write-Debug "Adding $($PSItem) to hashtable"
    $pair = [pscustomobject]@{
      $upperChar[($PSItem - 27)] = $PSItem
    }
    $Alpha.Add($pair)
  })

$AllAlphas = @()
$AllAlphas += $lowerChar.foreach({ @{$PSItem = @() } })
$AllAlphas += $upperChar.foreach({ @{$PSItem = @() } })
$Score = 0


# Loop through the data (Lines)
$Data.ForEach({
    $thisData = $PSItem
    # Split the lines in half, assigning to two separate compartment variables
    [char[]]$Compartment1 = $PSItem.Substring(0, $PSItem.Length / 2)
    [char[]]$Compartment2 = $PSItem.Substring($PSItem.Length / 2, $PSItem.Length / 2)
    # find the duplicate letter between the two compartments
    $Duplicate = Compare-Object $Compartment1 $Compartment2 -IncludeEqual | Where-Object { $_.SideIndicator -eq "==" } | Select-Object -Unique -ExpandProperty InputObject
    #Write-Debug "Duplicate letter is $Duplicate"
    # get the priority of the duplicate letter
    # ($Alpha -cmatch 's'|Select-Object -First 1).s
    $Priority = ($Alpha -cmatch $Duplicate | Select-Object -First 1).$Duplicate
    $Score += $Priority
  })
Write-Host "(Part 1) " -ForegroundColor Yellow -NoNewLine; Write-Host "Score is : " -NoNewLine; Write-Host "$Score" -ForegroundColor Green

$NewData = [List[char[]]]::new()
$Data.ForEach({
    $NewData.Add(($PSItem -as [char[]]))
  })

# Loop through every 3 items in $NewData 
# Using the Linq library's Enumerable class's Intersect method, find the duplicate letter between the three instances. 
# Assign the duplicate letter to the variable $Badge.
# Get the priority of the duplicate letter from the hashtable $Alpha
# Keep track of the occurences of that Priority by adding to the variable $Score

function getDuplicateFromLists {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [System.Collections.Generic.List[char[]]]$Lists
  )
  # For each list in $Lists compare against all other lists using the Linq.Enumerable Intersect method to determine which item is shared between all lists. Return the item.
  $_matches = @()
  for ($i = 0; $i -lt $Lists.Count; $i++) {
    for ($x = $i + 1; $x -lt $Lists.Count; $x++) {
      [System.Linq.Enumerable]::Intersect($Lists[$i], $Lists[$x]) | ForEach-Object {
        $_matches += $_
      }
    }
  }
  # Get the item that occurs the number of times equal to the number of lists 

  $_matches | Group-Object | Sort-Object -Descending -Property Count | Select-Object -First 1 -ExpandProperty Name
}

$Score = 0
$StartIndex = 0
$EndIndex = 2
for ($i = 0; $i -lt $NewData.Count / 3; $i++) {
  Write-Debug "StartIndex: $StartIndex, EndIndex: $EndIndex"
  if ($startindex -gt $NewData.Count - 2) {
    break
  }
  $indexes = $StartIndex..$EndIndex
  $i0, $i1, $i2 = $NewData[$indexes]
  $Badge = getDuplicateFromLists @($i0, $i1, $i2) -ErrorAction SilentlyContinue
  Write-Verbose "Duplicate is $Badge"
  $Priority = ($Alpha -cmatch $Badge | Select-Object -First 1).$Badge
  $Score += $Priority
  $StartIndex += 3
  $EndIndex += 3
}
Write-Host "(Part 2) " -ForegroundColor Yellow -NoNewLine; Write-Host "Score is : " -NoNewLine; Write-Host "$Score" -ForegroundColor Green

