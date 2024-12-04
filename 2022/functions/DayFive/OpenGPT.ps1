function GetTopCrates([int]$numStacks, [string]$startingPositions, [string]$instructions) {
  # Parse the starting positions string to create an array of stacks
  $stacks = $startingPositions -split '\r\n' | ForEach-Object {
    # Split each line of the starting positions string into an array of crates
    # and remove any leading or trailing whitespace from each crate
    $_.Split() | ForEach-Object { $_.Trim() }
  }

  # Split each element of the $stacks array into an array of individual characters
  $stacks = $stacks | ForEach-Object { $_.Split('') }

  # Split the instructions string into an array of individual instructions
  $instructions = $instructions -split '\r\n'

  # Iterate over the list of instructions and apply each one to the array of stacks
  foreach ($instruction in $instructions) {
    # Split the instruction string into its individual parts
    $parts = $instruction -split ' '

    # Extract the number of crates to move, the source stack, and the destination stack
    # from the instruction string
    $numCrates = $parts[1]
    $sourceStack = $parts[3]
    $destinationStack = $parts[5]

    # Move the specified number of crates from the source stack to the destination stack\
    
    $stacks[$destinationStack - 1] += [Linq.Enumerable]::Take($stacks[$sourceStack - 1], $numCrates)
    $stacks[$sourceStack - 1] = [Linq.Enumerable]::Skip($stacks[$sourceStack - 1], $numCrates)
    # $stacks[$sourceStack - 1] = $stacks[$sourceStack - 1].Skip($numCrates)
  }

  # Iterate over the array of stacks and return the top crate from each stack
  foreach ($stack in $stacks) {
    $stack[0]
  }
}



# Define the input data
$numStacks = 3
$startingPositions = @"
[Z] [N]
[M] [C] [D]
[P]
"@
$instructions = @"
move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"@

# Solve the problem and print the result
GetTopCrates $numStacks $startingPositions $instructions
