Set-Location $PSScriptRoot

# Get the preview data for Day Five from the subdirectory 'res'
$PreviewData = Get-Content $PSScriptRoot\res\DayFivePreviewData.txt

# Get the full data for Day Five from the subdirectory 'res'
$FullData = Get-Content $PSScriptRoot\res\DayFiveData.txt

# For both the Preview and Full data Parse that data into two objects, one for the data between "#region Stacks" and "#endregion Stacks" and one for the data between "#region Moves" and "#endregion Moves"

# Create a function to parse the data into the two objects
function Split-Data {
  param(
    [Parameter(Mandatory = $true)]
    [object[]]
    $Data
  )
  $Stacks = @()
  $Moves = @()
  $StacksStartIndex = $Data.IndexOf('#region Stacks')
  $StacksEndIndex = $Data.IndexOf('#endregion Stacks')
  $MovesStartIndex = $Data.IndexOf('#region Moves')
  $MovesEndIndex = $Data.IndexOf('#endregion Moves')
  $StacksData = $Data[($StacksStartIndex + 1)..($StacksEndIndex - 1)]
  $MovesData = $Data[($MovesStartIndex + 1)..($MovesEndIndex - 1)]
  $Columns = $StacksData[-1].Trim().Replace('   ', ' ').replace(' ', ',')
  $Stacks = @{}
  # $Columns.Split(',').ForEach({ 
  #     $Stacks[($PSItem.ToString() -as [char])] = @() 
  #   })
  
  $StacksData[0..($Stacks.Count - 1)].forEach({
      # $Stacks[$i] = 
      # If a line isn't as long as the last line, insert spaces to make it the same length
      $Line = $PSItem
      if ($Line.Length -lt $StacksData[-1].Length) {
        $Line = $Line + ' ' * ($StacksData[-1].Length - ($Line.Length - 1))
      }
      $SplitLine = $PSItem.Split(' ', 3, $null)
      for ($i = 0; $i -lt $($Columns.split(',')).Count; $i++) {
        # $SplitLine[$i] = $SplitLine[$i].Trim()
        Write-Debug "SplitLine[$i] = $($SplitLine[$i])"
        Write-Debug "Stacks[$($i+1)] = $($Stacks[($i + 1).ToString()])"
        $Stacks.Item((($i + 1).ToString())) += $SplitLine[$i]
      }
      
    })
  @{
    Stacks = $Stacks
    Moves  = $MovesData
  }

}
