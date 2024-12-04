param(
  [switch]
  $sample
)
## part 1


class MatchObject {
  [int] $Green = 0;
  [int] $Blue = 0;
  [int] $Red = 0;
  $MatchPower = [int]1;


  MatchObject([int] $Green, [int] $Blue, [int] $Red) {
    $this.Green = $Green;
    $this.Blue = $Blue;
    $this.Red = $Red;
  }

  [bool] IsValid() {
    return (Test-MatchIsPossible -InputObject $this)
  }

  [int] GetMatchPower() {
    $items = @($this.Green, $this.Blue, $this.Red).Where({ $PSItem -ne 0 })
    $items.foreach({
        $this.MatchPower *= $PSItem
      })

    return $this.MatchPower
  }

}

class GameObject {
  [System.Collections.Generic.List[PSObject]] $Matches = @();
  [int] $GameId = 0;
  [int] $MinimumRed = 0;
  [int] $MinimumGreen = 0;
  [int] $MinimumBlue = 0;
  [int] $MinimumPower = 1;
  [int] $TotalRed = 0;
  [int] $TotalGreen = 0;
  [int] $TotalBlue = 0;
  [int] $TotalPower = 0;

  GameObject([int] $GameId) {
    $this.GameId = $GameId;
    $this.Matches = [System.Collections.Generic.List[PSObject]]::new();
    $this
  }

  GameObject() {
    $this.Matches = [System.Collections.Generic.List[PSObject]]::new();
    $this
  }

  AddMatch([PSObject] $Match) {
    $this.Matches.Add($Match)
  }

  GetMinimumRed() {
    $_minimumRed = $this.Matches.Red | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    Write-Debug "MinimumRed: $_minimumRed"
    $this.MinimumRed = $_minimumRed
  }

  GetMinimumGreen() {
    $this.MinimumGreen = $this.Matches.Green | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
  }

  GetMinimumBlue() {
    $this.MinimumBlue = $this.Matches.Blue | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
  }

  GetAllMinimums() {
    $this.GetMinimumRed()
    $this.GetMinimumGreen()
    $this.GetMinimumBlue()
  }

  GetTotalRed() {
    $this.TotalRed = $this.Matches.Red | Measure-Object -Sum | Select-Object -ExpandProperty Sum
  }

  GetTotalGreen() {
    $this.TotalGreen = $this.Matches.Green | Measure-Object -Sum | Select-Object -ExpandProperty Sum
  }

  GetTotalBlue() {
    $this.TotalBlue = $this.Matches.Blue | Measure-Object -Sum | Select-Object -ExpandProperty Sum
  }

  GetAllTotals() {
    $this.GetTotalRed()
    $this.GetTotalGreen()
    $this.GetTotalBlue()
  }

  [int] GetMinimumPower() {
    $items = @($this.MinimumRed, $this.MinimumGreen, $this.MinimumBlue).Where({ $PSItem -ne 0 })
    $items.foreach({
        $this.MinimumPower *= $PSItem
      })
    return $this.MinimumPower
  }
  [int] GetGamePower() {
    $this.TotalPower = $this.Matches | ForEach-Object { $PSItem.GetMatchPower() } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    return $this.TotalPower
  }

}

function Test-MatchIsPossible {
  param(
    [int]
    $MaxGreen = 13,
    [int]
    $MaxBlue = 14,
    [int]
    $MaxRed = 12,
    [MatchObject]
    $InputObject
  )
  begin {
    if ($null -eq $InputObject) {
      throw "InputObject is null"
    }

  }
  process {
    if ($InputObject.Green -gt $MaxGreen) {
      return $false
    }
    if ($InputObject.Blue -gt $MaxBlue) {
      return $false
    }
    if ($InputObject.Red -gt $MaxRed) {
      return $false
    }
    return $true
  }
  end {

  }
}

function Parse-InputString {
  param(
    [string]
    $InputString
  )
  begin {
    if ($InputString -eq $null) {
      throw "InputString is null"
    }
  }
  process {

    $gameId, $gameData = $InputString.Split(':')
    $gameId = $gameId.Split(' ')[1]
    Write-Debug "GameId: $gameId"
    $gameMatches = $gameData.Split(';')
    Write-Debug "$($gameMatches.Count) matches"
    $gameMatches = $gameMatches.Split(',').Trim()
    $gameObject = [GameObject]::new()
    Write-Debug "GameId: $gameId"
    Write-Debug "$($gameMatches.Count) matches"
    $gameObject.GameId = $gameId
    # $gameObject | Format-Table
    $gameMatches.ForEach({
        $thisMatch = [MatchObject]::new(0, 0, 0)
        if ($PSItem -like "*red*") {
          $thisMatch.Red = $PSItem.Split(' ')[0]
        }

        if ($PSItem -like "*green*") {
          $thisMatch.Green = $PSItem.Split(' ')[0]
        }

        if ($PSItem -like "*blue*") {
          $thisMatch.Blue = $PSItem.Split(' ')[0]
        }
        if ($null -ne $thisMatch) {
          $gameObject.AddMatch($thisMatch)
        }
      })
  }
  end {
    $gameObject
  }
}

function Get-PossibleGameSum {
  param(
    [GameObject[]]
    $GameObjects,
    [int]
    $MaxGreen = 13,
    [int]
    $MaxBlue = 14,
    [int]
    $MaxRed = 12
  )
  begin {
    if ($null -eq $GameObjects) {
      throw "GameObjects is null"
    }
  }
  process {
    $possibleGameSum = 0
    $GameObjects.foreach({
        $tests = $PSItem.Matches | ForEach-Object { $PSItem.IsValid() }
        if ($false -notin $tests) { $possibleGameSum += $PSItem.GameId }
      })
  }
  end {
    $possibleGameSum
  }
}


# Set-Location "C:\Repos\AdventOfCode\2023\Day2\"
# Write-Debug "Current location: $PWD"
Write-Debug "Getting sample data"
$sampleData = Get-Content .\Sample.txt
Write-Host "Sample data count: $($sampleData.Count)"
Write-Debug "Getting real data"
$realData = Get-Content .\Input.txt
Write-Debug "Parsing sample data"
$output = $realData | ForEach-Object { Parse-InputString -InputString $PSItem }
if ($sample) {
  $output = $sampleData | ForEach-Object { Parse-InputString -InputString $PSItem }
}
Write-Debug "Getting Minimums"
$output.foreach({
    $PSItem.GetAllMinimums()
    $PSItem.GetAllTotals()
    $PSItem.GetMinimumPower()
    $PSItem.GetGamePower()
  });

$PowerSum = $output.MinimumPower | Measure-Object -Sum | Select-Object -ExpandProperty Sum
Write-Host "PowerSum: $PowerSum"
#Get-PossibleGameSum -GameObjects $output