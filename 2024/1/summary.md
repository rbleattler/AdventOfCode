# Day 1: Historian Hysteria - Summary

In the Advent of Code 2024 Day 1 puzzle, "Historian Hysteria," you're tasked with reconciling two lists of location IDs compiled by Elvish Senior Historians. The goal is to determine the total "distance" between these lists by following these steps:

1. **Sort both lists** in ascending order.
2. **Pair** the smallest elements from each list, then the second smallest, and so on.
3. For each pair, **calculate the absolute difference** between the two numbers.
4. **Sum** all the absolute differences to obtain the total distance.

For example, given the lists:

```json
Left list:  [3, 4, 2, 1, 3, 3]
Right list: [4, 3, 5, 3, 9, 3]
```

After sorting:

```json
Left list:  [1, 2, 3, 3, 3, 4]
Right list: [3, 3, 3, 4, 5, 9]
```

Pairing and calculating differences:

```pwsh
(1, 3) → |1 - 3| = 2
(2, 3) → |2 - 3| = 1
(3, 3) → |3 - 3| = 0
(3, 4) → |3 - 4| = 1
(3, 5) → |3 - 5| = 2
(4, 9) → |4 - 9| = 5
```

Total distance: `2 + 1 + 0 + 1 + 2 + 5 = 11`

Your task is to apply this method to the provided lists of location IDs to find their total distance.
