Set-Location $PSScriptRoot

# The data is represented as pairs of comma separated numeric ranges, for example:
# 1-3,5-7
# 1-4,8-11


# Get the preview data for Day Four from the subdirectory 'res'
$PreviewData = Get-Content $pwd\res\DayFourPreviewData.txt

# Get the full data for Day Four from the subdirectory 'res'
$FullData = Get-Content $pwd\res\DayFourData.txt

# Pre-process the data
# Split each item in the PreviewData array into two arrays defined by the hyphen separated values, where the left value is the lower bound and the right value is the upper bound.
# Store the new pairs of ranges in a new List of pairs of arrays called ProcessedPreviewData


$ProcessedPreviewData = @()
$PreviewData.ForEach({ 
    $stepOne = $PSItem.split(',') 
    $Pair = @{
      range0 = 0..0
      range1 = 0..0
    }
    0..1 | ForEach-Object {
      $lower, $upper = $stepOne[$PSItem].split('-')
      $Pair["range$($PSItem)"] = [system.collections.generic.list[int]]($lower..$upper)
    }
    $ProcessedPreviewData += $Pair
  })

# Do the same for the full Data
$ProcessedFullData = @()
$FullData.ForEach({ 
    $stepOne = $PSItem.split(',') 
    $Pair = @{
      range0 = 0..0
      range1 = 0..0
    }
    0..1 | ForEach-Object {
      $lower, $upper = $stepOne[$PSItem].split('-')
      $Pair["range$($PSItem)"] = [system.collections.generic.list[int]]($lower..$upper)
    }
    $ProcessedFullData += $Pair
  })

#region Part One
$OverLappedCount = 0
# Loop through each pair of ranges in the Data (or PreviewData for validation). Determine if one of the ranges fully overlaps the other. If they do, increment the OverLappedCount

$ProcessedPreviewData | ForEach-Object {
  $r0Inr1 = $PSItem.range0.TrueForAll({ param($item) $PSItem.range1.Contains($item) })
  $r1Inr0 = $PSItem.range1.TrueForAll({ param($item) $PSItem.range0.Contains($item) })
  # create strings for the ranges for output messages
  $r0string = $PSItem.range0 -join ','
  $r1string = $PSItem.range1 -join ','
  Write-Debug "r0string: $r0string"
  Write-Debug "r1String: $r1string"
  Write-Debug "r0Inr1: $r0Inr1"
  Write-Debug "r1Inr0: $r1Inr0"
  
  if ($r0Inr1 -or $r1Inr0) {
    Write-Host "Overlapping ranges found, adding to count. [Total: $OverLappedCount]"
    $OverLappedCount++
  }

}

# Do the same for the full Data
$PreviewShouldBe = 2
Write-Host "Overlapping Count in Preview Data: $OverLappedCount"
if ($OverlappedCount -eq $PreviewShouldBe) {
  Write-Host "Preview Process is" -NoNewline; Write-Host -ForegroundColor Green "correct"
} else {
  Write-Host "Preview Process is" -NoNewline; Write-Host -ForegroundColor Red "incorrect"
}

$OverlappedCount = 0
Write-Host "Processing Full Data"
$ProcessedFullData | ForEach-Object {
  $r0Inr1 = $PSItem.range0.TrueForAll({ param($item) $PSItem.range1.Contains($item) })
  $r1Inr0 = $PSItem.range1.TrueForAll({ param($item) $PSItem.range0.Contains($item) })
  # create strings for the ranges for output messages
  $r0string = $PSItem.range0 -join ','
  $r1string = $PSItem.range1 -join ','
  Write-Debug "r0string: $r0string"
  Write-Debug "r1String: $r1string"
  Write-Debug "r0Inr1: $r0Inr1"
  Write-Debug "r1Inr0: $r1Inr0"
  
  if ($r0Inr1 -or $r1Inr0) {
    Write-Host "Overlapping ranges found, adding to count. [Total: $OverLappedCount]"
    $OverLappedCount++
  }

}

Write-Host "Overlapping Count in Data: $OverLappedCount"


#endregion Part One

# Do the same, except don't look for ranges that have total overlap, look for ranges that have ANY overlap

$ProcessedPreviewData | ForEach-Object {
  $r0Inr1 = $PSItem.range0.TrueForAll({ param($item) $PSItem.range1.Contains($item) })
  $r1Inr0 = $PSItem.range1.TrueForAll({ param($item) $PSItem.range0.Contains($item) })
  # create strings for the ranges for output messages
  $r0string = $PSItem.range0 -join ','
  $r1string = $PSItem.range1 -join ','
  Write-Debug "r0string: $r0string"
  Write-Debug "r1String: $r1string"
  Write-Debug "r0Inr1: $r0Inr1"
  Write-Debug "r1Inr0: $r1Inr0"
  
  if ($r0Inr1 -or $r1Inr0) {
    Write-Host "Overlapping ranges found, adding to count. [Total: $OverLappedCount]"
    $OverLappedCount++
  }

}

#region Part Two
$OverLappedCount = 0
$ProcessedPreviewData | ForEach-Object {
  $r0inr1 = $PSItem.range0.FindAll({ param($item)$PSItem.range1.Contains($item) }).Count -gt 0
  $r1inr0 = $PSItem.range1.FindAll({ param($item)$PSItem.range0.Contains($item) }).Count -gt 0
  # create strings for the ranges for output messages
  $r0string = $PSItem.range0 -join ','
  $r1string = $PSItem.range1 -join ','
  Write-Debug "r0string: $r0string"
  Write-Debug "r1String: $r1string"
  Write-Debug "r0Inr1: $r0Inr1"
  Write-Debug "r1Inr0: $r1Inr0"

  if ($r0inr1 -or $r1inr0) {
    Write-Host "Overlapping ranges found, adding to count. [Total: $OverLappedCount]"
    $OverLappedCount++
  }
}
Write-Host "Overlapping Count in Preview Data: $OverLappedCount"

$OverLappedCount = 0
Write-Host "Processing Full Data"
$ProcessedFullData | ForEach-Object {
  $r0inr1 = $PSItem.range0.FindAll({ param($item)$PSItem.range1.Contains($item) }).Count -gt 0
  $r1inr0 = $PSItem.range1.FindAll({ param($item)$PSItem.range0.Contains($item) }).Count -gt 0
  # create strings for the ranges for output messages
  $r0string = $PSItem.range0 -join ','
  $r1string = $PSItem.range1 -join ','
  Write-Debug "r0string: $r0string"
  Write-Debug "r1String: $r1string"
  Write-Debug "r0Inr1: $r0Inr1"
  Write-Debug "r1Inr0: $r1Inr0"

  if ($r0inr1 -or $r1inr0) {
    Write-Host "Overlapping ranges found, adding to count. [Total: $OverLappedCount]"
    $OverLappedCount++
  }
}
Write-Host "Overlapping Count in Full Data: $OverLappedCount"


#endregion Part Two


#region Validate Solution Against Preview Data


#endregion Validate Solution Against Preview Data