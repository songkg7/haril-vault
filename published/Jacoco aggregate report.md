---
title: "Jacoco aggregate report"
date: 2022-09-28 15:03:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-28
aliases: 
tags: [test, jacoco, java]
categories: 
---

## Overview

multi project 의 경우 project 별 생성되는 jacoco coverage 결과를 어떻게 집계할 수 있는지 알아본다.

## Content

gradle multi project 의 경우, jacocoTestReport 에서 제외한 package 및 class 들이 여전히 표시되고 있다. 버그라고 생각되지만, 아래처럼 설정할 경우 정상적으로 project 별 제외될 package 를 설정할 수 있다.

```groovy
testCodeCoverageReport {
    reports {
        csv.required = true
        xml.required = false
    }
    getClassDirectories().setFrom(files(
        [project(':api'), project(':utils'), project(':core')].collect {
            it.fileTree(dir: "${it.buildDir}/classes/java/main", exclude: [
                '**/dto/**',
                '**/config/**',
                '**/output/**',
            ])
        }
    ))
} 
```
