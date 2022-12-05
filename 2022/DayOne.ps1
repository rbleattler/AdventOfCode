$elfCalories = (Get-Content $pwd\res\DayOneData.txt -Raw).Split("`r`n`r`n")

# find the sum of the calories carried by the elf carrying the most calories
$TopCalories = $elfcalories.ForEach({
    $elf = $_
    $AllFoods = $elf.Split("`r`n") 
    $i = 0
    $AllFoods.Foreach{ $i += $PSItem }
    $i
  }) | Sort-Object -Descending | Select-Object -First 1

# repeat part one for the top 3 elves, then sum the total
$Top3CaloriesSum = 0
$Top3Elves = $elfcalories.ForEach({
    $elf = $_
    $AllFoods = $elf.Split("`r`n") 
    $i = 0
    $AllFoods.Foreach{ $i += $PSItem }
    $i
  }) | Sort-Object -Descending | Select-Object -First 3 
$Top3Elves | ForEach-Object { $Top3CaloriesSum += $PSItem }

Write-Host "Top Calories : " -NoNewline; Write-Host "$TopCalories" -ForegroundColor Green
Write-Host "Top 3 Calories : "; $Top3Elves.ForEach({ Write-Host "$PSItem" -ForegroundColor Green })
Write-Host "Sum of top 3 calories: " -NoNewline; Write-Host "$top3sum" -ForegroundColor Green