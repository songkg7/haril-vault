---
title: axion-release-plugin
date: 2024-12-28T00:00:00
aliases: 
tags:
  - gradle
  - tag
  - release
description: 
updated: 2025-01-07T00:35
---

[GitHub - allegro/axion-release-plugin: Gradle release & version management plugin.](https://github.com/allegro/axion-release-plugin)

```groovy
plugins {
    id("pl.allegro.tech.build.axion-release") version "1.18.7"
}

version = scmVersion.version
```

- 다소 복잡한 설정
- ssh signing 방식 미지원
	- 의존하고 있는 jgit 에서 미지원하기 때문인데 최근 버전에서는 지원 가능
	- 다만 아직 의존성 업데이트가 이루어지지 않음
- CI 와 긴밀한 통합 가능

[[release-it]] 에 비하면 [[Gradle]] 에 좀 더 최적화되어 있긴 하다.
