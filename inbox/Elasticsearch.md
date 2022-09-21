---
title: "Elasticsearch"
date: 2022-09-20 17:36:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-20
aliases: 
tags: [elasticsearch, elk, java, kotlin]
categories:
---

## Overview

> [!INFO] 이 아티클의 메인 언어는 Kotlin 입니다.
>  Java 와 Kotlin 모두 예제를 제공하지만, 이 글에서는 Kotlin 을 위주로 설명합니다. Example code 는 Github 를 참조해주세요.

[spring-data-elasticsearch 4.0.0 설정과 기본 활용](http://www.donsdev.me/devlogs/140) 에서 설명하는 내용 중 일부는 Deprecated 되었으며 [Spring Data Elasticsearch 설정 및 검색 기능 구현](https://tecoble.techcourse.co.kr/post/2021-10-19-elasticsearch/) 에 나오는 `RestHighLevelClient` 또한 Deprecated 되었다. 꽤나 빠른 속도로 개발이 이루어지는건지는 모르겠지만, 버전이 올라갈 때마다 많은 내용이 새로 추가되고 deprecated 되므로 이 글에서 설명하는 내용 또한 금방 deprecated 될지도 모르겠다.

항상 새로운 내용이 생기니 이 글을 보시는 분들도 공식 문서를 최대한 참고하시길 바란다.

## version check

`RestHighLevelClient` 는 `Deprecated` 되었으므로 이후 사용시에는 `Elasticsearch Java API Client` 를 사용하도록 하자.

`@PersistenceConstructor` 도 Deprecated 되고 `@PersistenceCreator` 로 그 기능이 옮겨갔다.

## Reference

- [Elasticsearch Java API Client](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/introduction.html)
- [spring-data-elasticsearch 4.0.0 설정과 기본 활용](http://www.donsdev.me/devlogs/140)
- [Spring Data Elasticsearch 설정 및 검색 기능 구현](https://tecoble.techcourse.co.kr/post/2021-10-19-elasticsearch/)
