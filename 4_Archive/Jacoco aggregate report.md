---
title: Jacoco aggregate report
date: 2022-09-28 15:03:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-28
aliases: 
tags:
  - test
  - jacoco
  - java
categories: 
updated: 2024-09-09 09:35:44 +0900
---

[[Java]]

[[Jacoco]]

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

### jacoco.gradle

별도의 gradle 파일로 분리해두기

```groovy
// gradle/jacoco.gradle
subprojects {
    apply plugin: 'java-library'
    apply plugin: 'jacoco'

    repositories {
        mavenCentral()
    }

    jacoco {
        toolVersion = "${jacocoToolVersion}"
    }

    test {
        useJUnitPlatform()
        finalizedBy 'jacocoTestReport'
    }

    var excludeFromCoverage = new ArrayList<String>()
//    file('coverage-exclude.ocean-domain').withInputStream(){
//        it -> excludeFromCoverage.addAll(new BufferedReader(new InputStreamReader(it))
//                .lines()
//                .parallel()
//                .map(s -> s.substring(7).strip())
//                .toList())
//    }
    jacocoTestReport {
        reports {
            html.required = true
            csv.required = true
            xml.required = true
        }
        finalizedBy 'jacocoTestCoverageVerification'
        dependsOn test

        afterEvaluate {
            classDirectories.setFrom(files(classDirectories.files.collect {
                fileTree(dir: it, exclude: excludeFromCoverage.stream()
                        .map(s -> s + ".class")
                        .toList())
            }))
        }
    }

    jacocoTestCoverageVerification {
        violationRules {

            rule {
                enabled = true
                element = 'CLASS'
                excludes += excludeFromCoverage.stream()
                        .map(s -> s.replace("/", "."))
                        .toList()

                limit {
                    counter = 'LINE'
                    value = 'COVEREDRATIO'
                    minimum = 0.00
                }

                limit {
                    counter = 'BRANCH'
                    value = 'COVEREDRATIO'
                    minimum = 0.00
                }
            }
        }
    }
}

var allProjects = getAllprojects().stream()
        .filter(p -> !p.getDisplayName().contains('root project'))
        .toList()

var allProjectsExcludeJacoco = allProjects.stream()
        .filter(p -> !p.getDisplayName().contains('coverage-report')
                && !p.getDisplayName().contains('root project'))
        .toList()
var excludeFromCoverage = List.of()

project(':coverage-report') {
    apply plugin: 'jacoco-report-aggregation'

    testCodeCoverageReport {
        reports {
            csv.required = true
            xml.required = true
            html.required = true
        }
        getClassDirectories().setFrom(files(
                allProjects
                        .collect {
                            it.fileTree(dir: "${it.buildDir}/classes/java/main",
                                    exclude: excludeFromCoverage.stream()
                                            .map(s -> s + ".class")
                                            .toList())
                        })
        )
    }

    dependencies {
        implementation allProjectsExcludeJacoco
    }
}
```
