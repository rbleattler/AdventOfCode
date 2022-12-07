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
  $Columns = $StacksData[-1].Trim().Replace('   ',' ').replace(' ',',')
  @{
    Columns = $Columns
    Stacks = $StacksData
    Moves  = $MovesData
  }

}