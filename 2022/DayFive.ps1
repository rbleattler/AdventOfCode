Set-Location $PSScriptRoot
# Import functions for this day
Get-ChildItem $PSScriptRoot\functions\DayFive -Filter *.ps1 | ForEach-Object { . $PSItem.FullName }

# Get the preview data for Day Five from the subdirectory 'res'
$PreviewData = Get-Content $PSScriptRoot\res\DayFivePreviewData.txt

# Get the full data for Day Five from the subdirectory 'res'
$FullData = Get-Content $PSScriptRoot\res\DayFiveData.txt


# For both the Preview and Full data Parse that data into two objects, one for the data between "#region Stacks" and "#endregion Stacks" and one for the data between "#region Moves" and "#endregion Moves"

# Create a function to parse the data into the two objects







(Split-Data $PreviewData)
