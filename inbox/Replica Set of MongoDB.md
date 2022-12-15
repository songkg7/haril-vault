---
title: "Replica Set of MongoDB"
date: 2022-12-15 20:03:00 +0900
aliases: 
tags: [mongodb, replica]
categories: MongoDB
---

## Overview

[[MongoDB]] 의 Replica Set 에 대해 알아본다.

| Status    | Description                                         |
| --------- | --------------------------------------------------- |
| Primary   | Read/Write 요청 모두 처리할 수 있다.                |
|           | Write 를 처리하는 유일한 멤버이다.                  |
|           | Replica Set 에 **하나만 존재**할 수 있다.               |
| Secondary | Read 에 대한 요청만 처리할 수 있다.                 |
|           | 복제를 통해 Primary 와 동일한 데이터 셋을 유지한다. |
|           | Replica Set 에 여러개가 존재할 수 있다.             |

아무런 설정 없이 읽기 쓰기 요청을 할 경우, Primary 가 모든 요청을 처리하기 때문에 Secondary 는 그냥 Fail-Over 를 위한 용도로밖에 사용할 수 없다.

Replica Set 으로 자동 Fail-Over 가 보장되기 때문에 HA 가 보장되는 솔루션이라고 할 수 있다.

### Primary election

Replica Set 에서 Primary 가 죽게 된다면 Primary 를 선출하게 된다. 과반수의 투표를 얻어야 하기 때문에 replica 는 최소 3개 이상의 홀수로 구성하는 것이 추천된다.

### Arbiter

투표를 할 수 있는 멤버는 Primary, Secondary 외에도 하나 더 있는데 Arbiter 라는 멤버이다. 데이터를 들고 있지 않고 vote only 의 속성을 지니고 있다. 이 구성으로 replica 를 구성하게 되면 P-S-A 라고 부른다. 비용을 최소화하기 위해서 사용할 수 있는데, 데이터를 들고 있지 않기 때문에 최소한의 사양을 가진 서버를 Arbiter 로 할당하고 투표권을 홀수로 유지하여 Primary 선출과정의 장애를 회피하기 위해 사용될 수 있다. 하지만 비용 문제가 아니라면 그렇게 권장되는 구성방식은 아니다. P-S-S 에서는 둘 중 하나의 Secondary 가 다운되더라도 Primary 의 부하가 직접적으로 상승하지는 않지만, P-S-A 에서는 Secondary 의 다운이 Primary 의 부하를 직접적으로 상승시킬 수 있다.

### Oplog

Replica Set 의 모든 멤버가 동일한 데이터를 유지할 수 있도록 한다. primary 의 변경사항을 로그 정보로써 기록해두는데, 다른 secondary 들은 로그를 보고 변경을 감지하여 데이터를 비동기적으로 반영한다.

여기서 재밌는 점은, Secondary 는 복제되는 데이터를 항상 Primary 에서 가져오는 것이 아니라 자기보다 더 빨리 반영된 Secondary 에서도 가져올 수 있다는 점이다.
