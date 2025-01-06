---
title: Amazon S3 mocking
date: 2023-02-23T15:54:00
aliases: 
tags:
  - test
  - aws
  - amazon
  - s3
  - mock
  - adobe
  - s3mock
categories: 
updated: 2025-01-07T00:35
---

AWS SDK 를 사용하여 S3 를 테스트할 수 있는 방법을 고민해보고 정리합니다.

## Overview

## Contents

### 라이브러리 선택

Google 에 검색해보면 [findify](https://github.com/findify/s3mock) 에 관한 글이 다수인 듯 합니다. 하지만 이 라이브러리는 업데이트되지 않은지 3년째라 믿고 사용할 수 있을까에 대한 의문이 있었습니다.

그래서 비교적 최근까지 업데이트가 활발한 adobe 의 S3 mock 을 선택하게 되었는데, 나름 알려진 회사인 adobe 에서 개발하고 있어서 아무래도 신뢰성이 더 높았습니다.

AWS SDK 는 2.x 를 사용합니다. `build.gradle` 에 다음과 같이 dependency 를 작성합니다.

```java
dependencies {
 implementation platform('software.amazon.awssdk:bom:2.15.0')
 implementation 'software.amazon.awssdk:s3'
}
```

### TestContainer

`S3Mock` 은 다양한 방법으로 테스트코드를 구현할 수 있지만, 테스트와의 의존성 분리를 위해 docker 기반의 `TestContainer` 를 사용하도록 했습니다.



## Reference

- [Adobe s3mock](https://github.com/adobe/S3Mock)
- [AWS SDK for Java]()
