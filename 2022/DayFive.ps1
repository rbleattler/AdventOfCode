Set-Location $PSScriptRoot

# Get the preview data for Day Five from the subdirectory 'res'
$PreviewData = Get-Content $PSScriptRoot\res\DayFivePreviewData.txt

# Get the full data for Day Five from the subdirectory 'res'
$FullData = Get-Content $PSScriptRoot\res\DayFiveData.txt


function Write-FilterMessage {
  param($FilteredStackData, $StartIndex, $EndIndex)
  $FilteredStackData[$StartIndex..$EndIndex] | ForEach-Object { 
    $ProcessItem = $PSItem  
    if ([string]::IsNullOrWhiteSpace($ProcessItem)) { 
      Write-Debug "Found null entry"
      $ProcessItem = "_" 
    }
    [PSCustomObject]@{
      Index = $StartIndex
      Value = $ProcessItem
    }
  }
}


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
  $Columns = $StacksData[-1].Trim().Replace('   ', ' ').replace(' ', ',').split(',').foreach({ [char]$PSItem })
  $Stacks = @{}
  $Columns.ForEach({ 
      $Stacks[($PSItem.ToString())] = [System.Collections.Stack]::new()
    })
  
  [System.Collections.Generic.List[System.Object]]$FilteredStackData = ($StacksData[0..($Stacks.Count - 1)].Replace('[', '').Replace(']', '').Replace('   ', ' ').Replace('  ', ',')).ForEach({ 
      if ($PSItem -like "*,*") { 
        $PSItem.Split(',').split(' ')
      } else { 
        $PSItem.split(' ')
      } 
    })
  # I need to divide FilteredStackData by the total number of columns to get the total number of rows
  $Rows = $FilteredStackData.Count / $Columns.Count
  # For every $Rows number items FilteredStackData, create a new array containing those items
  $NewFilteredStackData = [System.Collections.Generic.List[System.Collections.Stack]]::new()
  # $Rows | ForEach-Object { 
  $Columns | ForEach-Object {
    $ParsedItem = [int]::Parse($PSItem) - 1
    $Skip = ($ParsedItem * $Rows)
    # $item = [System.Collections.Generic.List[System.Object]]($FilteredStackData | Select-Object -Skip (($PSItem - 1) * [int]::Parse($Rows)) -First $Rows)
    $item = $FilteredStackData | Select-Object -Skip $Skip -First $Rows 
    $item.Reverse()
    # $item.Length
    for ($i = 0; $i -lt ($item.Count); $i++) { 
    
      Write-Debug "$i : $($item[$i])"
      $null = $item[$i] ?? '_'
    }
    Write-Host "$($PSitem) : $item"
    
  }


  # $NewArray = [System.Object[]]::new(($Rows * $Columns.Count))
  for ($i = 0; $i -lt $Rows; $i++) { 
    # Get start index. Account for 0 based index
    if ($i -eq 0) { 
      $StartIndex = 0
    } else { 
      $StartIndex = $LasEndIndex + 1
    }
    $EndIndex = ($i + 1) * $Columns.Count
    
    Write-Output (Write-FilterMessage -FilteredStackData $FilteredStackData -StartIndex $StartIndex -EndIndex $EndIndex)

    # Write-Host "i:$i"
    # Write-Host "Data:$(($FilteredStackData[$i..($i + $Columns.Count - 1)]|Out-String).Replace(' ','_'))"
    [array]::ConstrainedCopy($FilteredStackData, $i, $NewArray, $i, $Columns.Count)
    $LastEndIndex = $EndIndex
  }


  $FilteredStackData[0..($Stacks.Count - 1)].forEach({
      # $Stacks[$i] = 
      # If a line isn't as long as the last line, insert spaces to make it the same length
      $Line = $PSItem
      if ($Line.Length -lt $FilteredStackData[-1].Length) {
        $Line = $Line + ' ' * ($FilteredStackData[-1].Length - ($Line.Length - 1))
      }
      $SplitLine = $PSItem.Split(' ', 3, $null)
      Write-Debug "SplitLine = $($SplitLine|Out-String)"
      Write-Debug "SplitLine Count = $($SplitLine.Count)"
      for ($i = 0; $i -lt $Columns.Count; $i++) {
        # $SplitLine[$i] = $SplitLine[$i].Trim()
        Write-Debug "SplitLine[$i] = $($SplitLine[$i])"
        Write-Debug "Stacks[$($i+1)] = $($Stacks[($i + 1).ToString()])"
        if (-not [string]::IsNullOrWhiteSpace($SplitLine[$i])) {
          $Stacks.Item((($i + 1).ToString())).Push($SplitLine[$i])
        }
      }
      
    })

  $Moves = $MovesData.ForEach({
      $parseRegex = [regex]"move (?<moveCount>\d*) from (?<startColumn>\d*) to (?<endColumn>\d*)"
      $regexMatches = $parseRegex.Match($PSItem)
      [pscustomobject]@{
        count = $regexMatches.Groups['moveCount'].Captures[0].Value
        start = $regexMatches.Groups['startColumn'].Captures[0].Value
        end   = $regexMatches.Groups['endColumn'].Captures[0].Value
      }
    })
  #TODO: Maybe convert the stacks to queues?

  @{
    Stacks = $Stacks
    Moves  = $Moves
  }

}








(Split-Data $PreviewData)
