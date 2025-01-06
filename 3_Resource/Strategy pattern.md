---
title: Strategy pattern
date: 2022-08-18T11:11:00
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-18
aliases: 
tags:
  - design-pattern
  - kotlin
  - kotest
categories:
  - Design pattern
updated: 2025-01-07T00:35
---

# Strategy pattern

가장 중요한 디자인 패턴 중 하나

## Overview

## Example

### Kotlin

```kotlin
package strategy  
  
class Printer(private val stringFormatterStrategy: (String) -> String) {  
  
    fun printString(string: String) {  
        println(stringFormatterStrategy(string))  
    }
}  
  
val lowerCaseFormatter: (String) -> String = { it.lowercase() }  
val upperCaseFormatter = { it: String -> it.uppercase() }
```

[[Kotlin]] 은 아주 간단하게 strategy pattern 을 구현할 수 있다. 

### Test

```kotlin
package strategy  
  
import io.kotest.core.spec.style.DescribeSpec  
  
internal class PrinterTest : DescribeSpec({  
  
    describe("printer") {  
        val lowerPrinter = Printer(lowerCaseFormatter)  
        val upperPrinter = Printer(upperCaseFormatter)  
  
        it("lower") {  
            lowerPrinter.printString("TEST") // test 
        }  
  
        it("upper") {  
            upperPrinter.printString("test") // TEST 
        }  
    }
})
```

`Printer` 를 생성할 때 주입되는 `Formatter` 에 따라서 동작이 결정된다.

## Conclusion

# Reference

# Links

- [[Design Pattern]]
