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