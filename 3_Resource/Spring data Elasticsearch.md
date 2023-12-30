---
title: Elasticsearch
date: 2022-09-20 17:36:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-20
aliases: 
tags:
  - spring
  - elasticsearch
  - elk
  - kotlin
categories: 
updated: 2023-09-19 22:53:41 +0900
---

> [!INFO] 이 아티클의 메인 언어는 Kotlin 입니다.
>  Java 와 Kotlin 모두 예제를 제공하지만, 이 글에서는 Kotlin 을 위주로 설명합니다. Example code 는 Github 를 참조해주세요.

## Overview

[[Spring framework|Spring]] 에서는 [[Elasticsearch]] 를 편리하게 사용할 수 있도록 다양한 설정이 준비되어 있다. 이 글에서는 클러스터링을 통한 Elasticsearch 설정과 Spring 에서는 어떻게 Elasticsearch 를 활용할 수 있는지 간단하게 정리해보려고 한다.

[spring-data-elasticsearch 4.0.0 설정과 기본 활용](http://www.donsdev.me/devlogs/140) 에서 설명하는 내용 중 일부는 Deprecated 되었으며 [Spring Data Elasticsearch 설정 및 검색 기능 구현](https://tecoble.techcourse.co.kr/post/2021-10-19-elasticsearch/) 에 나오는 `RestHighLevelClient` 또한 Deprecated 되었다. 꽤나 빠른 속도로 개발이 이루어지는건지는 모르겠지만, 버전이 올라갈 때마다 많은 내용이 새로 추가되고 deprecated 되므로 이 글에서 설명하는 내용 또한 금방 deprecated 될지도 모르겠다.

항상 새로운 내용이 생기니 이 글을 보시는 분들도 공식 문서를 최대한 참고하시길 바란다.

## version check

`RestHighLevelClient` 는 `Deprecated` 되었으므로 이후 사용시에는 `Elasticsearch Java API Client` 를 사용하도록 하자.

`@PersistenceConstructor` 도 Deprecated 되고 `@PersistenceCreator` 로 그 기능이 옮겨갔다.

## Elasticsearch 설정

[[Docker]] 를 사용하면 Elasticsearch 를 아주 간단하게 설치하고 사용할 수 있다. 간편하게 실행하려면 단일 노드로 사용하면 되지만, 실무에서 단일 노드로만 사용하는 경우는 거의 없을 것이라 생각되기 때문에 멀티 노드를 통한 클러스터링을 해보자.

```yaml
```

아래 명령을 통해 실행시킬 수 있다.

```bash
docker compose -f docker-compose-cluster.yml up -d
```

### Health check

Elasticsearch 가 제대로 클러스터링 되었는지 확인하기 위해 간단한 명령어를 통해 상태를 파악해보자. http 요청을 통해 확인할 수 있는데, 이 글에서는 [[HTTPie]] 를 사용한다. `curl` 이 익숙하신 분들은 `curl` 을 사용하시면 되겠다.

#### Cluster

```console
http GET "localhost:9200/_cat/health?v"
HTTP/1.1 200 OK
content-encoding: gzip
content-length: 194
content-type: text/plain; charset=UTF-8

epoch      timestamp cluster               status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1664610861 07:54:21  elasticsearch-cluster green           3         3      0   0    0    0        0             0                  -                100.0%
```

#### Nodes

```console
http GET "localhost:9200/_cat/nodes?v"
HTTP/1.1 200 OK
content-encoding: gzip
content-length: 166
content-type: text/plain; charset=UTF-8

ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.22.0.3           20          39  12    0.46    1.26     1.62 dilmrt    -      es03
172.22.0.4           22          39  31    0.46    1.26     1.62 dilmrt    *      es01
172.22.0.2           11          39  16    0.46    1.26     1.62 dilmrt    -      es02
```

현재 어떤 노드가 마스터인지, 매트릭 상태는 어떤지 간단하게 모니터링 할 수 있다.

## Example

elasticsearch 기본 환경이 준비되었으니 본격적으로 코드를 작성해보자.

Spring data Elasticsearch 는 많은 부분을 추상화하여 제공하기 때문에, 설정해야하는 부분이 많지는 않다.



## Reference

- [Elasticsearch Java API Client](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/introduction.html)
- [Spring-data-Elasticsearch 4.0.0 설정과 기본 활용](http://www.donsdev.me/devlogs/140)
- [Spring data Elasticsearch 설정 및 검색 기능 구현](https://tecoble.techcourse.co.kr/post/2021-10-19-elasticsearch/)
