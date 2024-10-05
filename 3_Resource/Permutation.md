---
title: 순열
date: 2024-05-29 00:19:00 +0900
aliases: 
tags:
  - algorithm
  - permutation
categories: 
updated: 2024-10-05 11:44:36 +0900
---

[[Implement Combination in Java|Java 로 조합 구현하기]]

## Backtrack

```java
class Solution {
    public List<List<Integer>> permuteUnique(int[] nums) {
        List<List<Integer>> result = new ArrayList<>();

        Map<Integer, Integer> counter = new HashMap<>();
        for (int num : nums) {
            counter.put(num, counter.getOrDefault(num, 0) + 1);
        }

        LinkedList<Integer> comb = new LinkedList<>();
        backtrack(comb, nums.length, counter, result);
        return result;
    }

    private void backtrack(
        LinkedList<Integer> comb,
        int n,
        Map<Integer, Integer> counter,
        List<List<Integer>> result
    ) {
        if (comb.size() == n) {
            result.add(new ArrayList<>(comb));
            return;
        }

        for (Map.Entry<Integer, Integer> entry : counter.entrySet()) {
            Integer num = entry.getKey();
            Integer count = entry.getValue();
            if (count == 0) {
                continue;
            }

            comb.addLast(num);
            counter.put(num, count - 1);

            backtrack(comb, n, counter, result);

            comb.removeLast();
            counter.put(num, count);
        }
    }
}
```
