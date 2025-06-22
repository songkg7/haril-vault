---
title: Spotless
date: 2025-06-22T21:05:12+09:00
aliases: 
tags:
  - formatter
description: 
updated: 2025-06-22T21:59
---

## Contents

```groovy
spotless {
    java {
        importOrder()
        removeUnusedImports()
        trimTrailingWhitespace()
        cleanthat()
        palantirJavaFormat()
        formatAnnotations()
        endWithNewline()
    }

    kotlin {
        ktlint()
        suppressLintsFor {
            step = 'ktlint'
            shortCode = 'standard:no-wildcard-imports'
        }
        endWithNewline()
    }

    kotlinGradle {
        ktlint()
    }

    json {
        target 'src/**/*.json'
        simple()
    }

    yaml {
        target 'src/**/*.yaml'
        jackson()
        prettier()
    }
}
```

- 코드 스타일을 지키지 않을 경우 빌드가 실패하도록 할 수 있음
- palantir format plugin 을 [[IntelliJ]] 에 설치하면 훨씬 효과적
- `.editorconfig` 파일을 우선적으로 적용하도록 설정하는 것도 가능
- ktlint 적용이 매우 쉬움
    - 최근 intellij 가 케어하지 못하고 있는 trailing comma 규칙도 잘 적용됨

## Reference

- [spotless/plugin-gradle/README.md at main · diffplug/spotless · GitHub](https://github.com/diffplug/spotless/blob/main/plugin-gradle/README.md)