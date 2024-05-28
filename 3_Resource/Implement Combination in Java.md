---
title: Java 로 조합 구현하기
date: 2024-05-20 11:59:00 +0900
aliases: 
tags: 
categories: 
updated: 2024-05-29 00:21:39 +0900
---

## Backtrack

```java
public List<List<Integer>> solution() {
    // ..
    List<List<Integer>> subsets = new ArrayList<>();
    generateSubsets(nums, 0, new ArrayList<>(), subsets);
    // ..
    return subsets;
}

private void generateSubsets(int[] nums, int index, List<Integer> subset, List<List<Integer>> subsets) {
    if (index == nums.length) {
        subsets.add(new ArrayList<>(subset));
        return;
    }
    subset.add(nums[index]);
    generateSubsets(nums, index + 1, subset, subsets);
    subset.remove(subset.size() - 1);
    generateSubsets(nums, index + 1, subset, subsets);
}
```

```java
class Solution {
    List<List<Integer>> output = new ArrayList();
    int n, k;

    public void backtrack(int first, ArrayList<Integer> curr, int[] nums) {
        // If the combination is done
        if (curr.size() == k) {
            output.add(new ArrayList(curr));
            return;
        }
        for (int i = first; i < n; ++i) {
            // Add i into the current combination
            curr.add(nums[i]);

            // Use the next integers to complete the combination
            backtrack(i + 1, curr, nums);

            // Backtrack
            curr.remove(curr.size() - 1);
        }
    }

    public List<List<Integer>> subsets(int[] nums) {
        n = nums.length;
        for (k = 0; k < n + 1; ++k) {
            backtrack(0, new ArrayList<Integer>(), nums);
        }
        return output;
    }
}
```
