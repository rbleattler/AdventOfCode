using namespace System.Collections.Generic;
[CmdletBinding()]
param(
  [switch]
  $exampleInput = $false,
  [bool]
  $cleanVars = $true
)
if ($exampleInput.IsPresent) {
  $AOC_INPUT_FILE = "$PSScriptRoot/exampleinput.txt"
} else {
  $AOC_INPUT_FILE = "$PSScriptRoot/input.txt"
}
$RAW_AOC_INPUT = Get-Content $AOC_INPUT_FILE -Raw
$AOC_INPUT = $RAW_AOC_INPUT.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)


function Get-SplitRawInput {
  [CmdletBinding()]
  [OutputType([List[int[]]])]
  param(
    [string[]] $InputObject,
    [switch] $noSort
  )
  process {
    $left = [List[Int]]::new()
    $right = [List[Int]]::new()
    $InputObject.ForEach({
        $split = $PSItem.Split().Where{ -not [string]::IsNullOrEmpty($PSItem) }
        $left.Add([int]::Parse($split[0]))
        $right.Add([int]::Parse($split[-1]))
      })
  }
  end {
    if ($noSort) {
      return @($left, $right)
    } else {
      return @(($left | Sort-Object), ($right | Sort-Object))
    }
  }
}

function Get-ListPairings {
  [CmdletBinding()]
  [OutputType([List[int[]]])]
  param(
    [int[]] $LeftArray,
    [int[]] $RightArray
  )
  begin {
    $outList = [List[int[]]]::new()
  }
  process {
    0..($LeftArray.Length - 1) | ForEach-Object {
      $outList.Add(@($LeftArray[$PSItem], $RightArray[$PSItem]))
    }
  }
  end {
    return $outList
  }
}

function Get-PairDistance {
  [CmdletBinding()]
  [OutputType([int])]
  param(
    [int[]] $Pair
  )
  process {
    $distance = [Math]::Abs($Pair[0] - $Pair[1])
    Write-Debug "[Abs] $($Pair[0]) - $($Pair[1]) = $distance"
    $distance
  }
}

function Get-ListDifference {
  [CmdletBinding()]
  [OutputType([int])]
  param(
    [int[]] $InputObject
  )
  process {
    $debugEquation = $InputObject -join " + "
    Write-Debug "Calculating list distance: $debugEquation"
    $sum = [int](($InputObject | Measure-Object -Sum).Sum)
    Write-Debug "List distance is $sum"
    $sum
  }
}

function Get-Diffs {
  [CmdletBinding()]
  [OutputType([int[]])]
  param(
    [List[int[]]] $Pairings
  )
  process {
    return [int[]]( $pairings | ForEach-Object { Get-PairDistance -Pair $PSItem });
  }
}

function Get-CombinedDistance {
  [CmdletBinding()]
  [OutputType([int])]
  param(
    [string[]] $InputObject
  )
  process {
    Write-Debug "Calculating distance for $($InputObject.Length) pairs"
    $leftArray, $rightArray = Get-SplitRawInput $InputObject -noSort
    $pairings = Get-ListPairings -LeftArray $leftArray -RightArray $rightArray
    $diffs = Get-Diffs -Pairings $pairings
    $sum = Get-ListDifference -InputObject $diffs
    return $sum
  }
}



Get-CombinedDistance -InputObject $AOC_INPUT

# Part 2: Find the similarity between the two lists

function Get-SimilarityScore {
  [CmdletBinding()]
  [OutputType([int])]
  param(
    [string[]] $InputObject
  )
  process {
    $leftArray, $rightArray = Get-SplitRawInput $InputObject
    $similarity = 0
    $leftArray.ForEach({
        $left = $PSItem
        Write-Debug "Checking for $left in right array"
        $rightCount = $rightArray.Where({ $PSItem -eq $left }).Count
        Write-Debug "Found $rightCount matches"
        $similarity += $left * $rightCount
      })
    return $similarity
  }
}

Get-SimilarityScore -InputObject $AOC_INPUT

if ($cleanVars) {
  'pairings', 'leftArray', 'rightArray', 'diffs', 'sum', 'splitInput', 'splitRawInput' | ForEach-Object { Remove-Variable $_ -ErrorAction SilentlyContinue }
}