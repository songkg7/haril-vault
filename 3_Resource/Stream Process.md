---
title: Stream Process
date: 2023-12-19T18:44:00
aliases: 
tags:
  - stream
  - study
  - message-broker
  - message-queue
  - kafka
categories: 
updated: 2025-01-07T00:35
---

# 스트림 처리

이벤트가 발생할 때마다 처리하는 것이 기본 개념

## 이벤트 스트림 전송

- 이벤트는 다양한 형태로 부호화된다.
- 생산자가 이벤트를 만들면 복수의 소비자가 처리할 수 있다.
- 관련 레코드 집합은 토픽(topic)이나 스트림(stream)으로 묶는다.
- 전통적인 데이터베이스에서도 기능이 제한되기는 하지만 트리거라는 기능을 통해 지원할 수 있다.

### 메시징 시스템

- 이벤트를 소비자에게 알려주기 위해 사용하는 일반적인 방법
- 유닉스 파이프나 TCP 연결과 같은 직접 통신 채널을 통해 간단하게 구축할 수 있다.
- 발행/구독 모델 등으로 다수의 소비자 노드가 하나의 토픽에서 메세지를 받아갈 수 있다.
- 메시지가 유실될 수 있는 가능성에 대해 이야기해볼 수 있다.

#### 생산자에서 소비자로 메시지를 직접 전달하기

> 직접 메시징 시스템

- 메시지가 유실될 수 있는 가능성을 고려해서 애플리케이션 코드를 작성해야 한다.
- 소비자가 오프라인라면 이 상태에서 전송된 메시지는 잃어버릴 수 있다.
- 실패했을 경우 생산자가 재시도하게 할 수 있지만, 여전히 생산자가 죽어버릴 경우 재시도하려고 했던 메시지 버퍼가 유실될 위험이 있다.

#### 메시지 브로커

> 직접 메시징 시스템의 대안, 메시지 큐라고도 한다.

- 메시지 스트림을 처리하는 데 최적화된 데이터베이스의 일종
- 브로커는 서버로 구동되고 생산자와 소비자는 서버의 클라이언트로 접속
- 브로커에 데이터가 모이기 때문에 클라이언트의 상태 변경에 쉽게 대처 가능
    - 지속성 문제가 생산자와 소비자에서 브로커로 옮겨갔기 때문
- 메시지가 유실되지 않게 하기 위해, 메모리 혹은 디스크에 메시지를 기록
- 큐 대기를 하면 생산자와 소비자 모두 **비동기**로 동작할 수 있다.

#### 메시지 브로커와 데이터베이스의 비교

- 메시지 브로커는 XA 또는 [[JTA]] 를 이용해 [[Two Phase Commit|2PC]] 를 수행하기도 한다.
- 메시지 브로커에서는 메시지가 소비자에게 성공적으로 전달되면 일반적으로 메시지가 삭제된다.
- 메시지 브로커는 특정 패턴과 부합하는 토픽의 부분 집합을 구독하는 방식을 지원한다. <=> 데이터베이스는 색인
- 메시지 브로커는 데이터가 변하면 클라이언트에게 알려준다. <=> 데이터베이스에 질의하는 것은 질의시점의 스냅숏이며, 이후 데이터가 변경되어도 먼저 질의한 클라이언트는 그 사실을 알 길이 없다.

#### 복수 소비자

두 가지의 주요 패턴

- 로드 밸런싱: 각 메시지는 소비자 중 **하나**로 전달된다. 성능 개선 등의 이유로 메시지 처리를 병렬화하기 위해 소비자를 추가하고 싶을 때 유용하다.
- 팬 아웃: 각 메시지는 **모든** 소비자에게 전달된다. 독립된 소비자가 같은 메시지에 다른 처리 방식을 적용하려할 때 유용하다.

소비자 그룹을 구성하면 위 방식을 함께 사용할 수 있다.

#### 확인 응답과 재전송

- 브로커가 메시지를 소비자에게 전달했지만 소비자가 메시지를 처리하지 못하거나 부분적으로만 처리한 이후 장애가 나는 경우가 생길 수 있다.
    - 메시지를 소비자에게 성공적으로 전달하기만 하면 브로커는 메시지를 삭제하기 때문에, 재처리하기 어려울 수 있다.
- 이 경우를 방지하기 위해 브로커는 **확인 응답**을 사용한다. 
    - 확인 응답? 클라이언트가 메시지 처리가 끝났음을 브로커에게 명시적으로 알리는 것
- 메시지가 실제로 완전히 처리되었어도 네트워크 상에서 확인 응답이 유실될 수 있으며, 이런 경우를 처리하기 위해 원자적 커밋 프로토콜이 필요하다.
- 재시도 과정에서 필연적으로 메시지 처리 순서가 변경될 수 있다.
    - 메시지가 서로 완전히 독립적이라면 별로 문제되지 않지만, 인과성이 있다면 매우 중요한 문제다.

### 파티셔닝된 로그

- 일반적으로 소비자는 구독하기 이전 시점의 메시지를 볼 수 없다. 메시지 브로커가 성공적으로 전달한 메시지는 삭제하기 때문이다.
- 소비자가 언제 구독을 시작하더라도 원하는 시점부터 데이터를 처리할 수 있도록 하기 위해 **로그 기반 메시지 브로커(log-based message broker)** 가 등장했다.

#### 로그를 사용한 메시지 저장소

> 로그는 디스크에 저장된 추가 전용 레코드의 연속

- 생산자가 보낸 메시지는 로그 끝에 추가(append)하고, 소비자는 로그를 순차적으로 끝까지 읽으며 메시지를 받는다.
- 소비자가 로그 끝에 도달하면 새 메시지가 추가됐다는 알림을 기다린다.
    - 유닉스 도구 `tail -f` 는 파일의 추가되는 데이터를 감시하는데 본질적으로는 이 구조와 동일하다.
- 데이터베이스와 유사하게 로그를 파티셔닝하는 방법으로 처리량을 높일 수 있다.
- 파티션 내에서 브로커는 모든 메시지에 **오프셋(offset)** 이라고 부르는, 단조 증가하는 순번을 부여하여 어디까지 처리되었는지를 알 수 있다.

#### 로그 방식과 전통적인 메시징 방식의 비교

순서대로 처리하기 때문에 특정 메시지 처리가 느리면 후속 메시지 처리가 지연(선두차단 문제)된다. => 데드레터 큐의 등장배경

- 메시지를 처리하는 비용이 비싸고 메시지 단위로 병렬처리하고 싶지만 순서가 중요하지 않다면? JMS/AMQP 방식
- 처리량이 많고 메시지를 처리하는 속도가 빠르지만 순서가 중요하다면? 로그 기반 접근법이 효과적

#### 소비자 오프셋

- 오프셋은 데이터베이스 복제에서 널리쓰는 로그 순차 번호와 유사하다.
- 소비자 노드에 장애가 발생하면 두 번 처리되는 메시지가 생길 수 있다.
    - 메시지에 멱등성을 부여해야하는 이유

#### 디스크 공간 사용

- 로그는 계속 추가되므로 디스크가 오버플로우되는 것을 막기위해 로그를 여러 조각으로 나누거나, 삭자하거나 이동될 수 있다.
- 소비자 처리 속도가 너무 느려 메시지 생산 속도를 따라잡지 못하면 소비자 오프셋이 이미 삭제한 조각을 가리킬 수도 있다.
    - 메시지 일부를 잃어버릴 수 있다는 뜻
    - [[Kafka]] 에서는 이를 렉(lack)이라고하며 모니터링의 중요한 지표
    - 처리 속도를 위해 메시지를 메모리에 유지하고 너무 커질 때만 디스크에 기록해야 한다. 따라서 보유한 메시지 양에 따라 처리량이 달라지게 된다.

#### 소비자가 생산자를 따라갈 수 없을 때

3가지 선택지가 있다.

1. 메시지 버리기
2. 버퍼링
3. 배압 적용하기

- 렉을 모니터링하면 사람이 처리할 수 있는 시간을 벌어줄 수 있다.
- 특정 소비자가 느려진다고 해서 전체 서비스에 영향을 주지는 않는다. 이는 운영상 상당한 장점이다.

#### 오래된 메시지 재생

- 오프셋을 조작하여 원하는 시점부터 다시 소비할 수 있다.
- 소비한 메시지가 사라지지 않기 때문에(읽기 연산), 부담없이 다양한 실험이 가능하다.

## 데이터베이스와 스트림

### 시스템 동기화 유지하기

- 서로 다른 클라이언트에서 동시에 데이터를 변경하려 시도할 때 에러가 발생하지 않아도 데이터가 불일치한채로 유지되는 문제가 발생할 수 있다.

### 변경 데이터 캡쳐

- [[Change Data Capture|CDC]] 는 데이터베이스에 기록하는 모든 데이터를 관찰해 다른 시스템으로 데이터를 복제할 수 있는 형태로 추출하는 과정
    - 변경 내용을 스트림으로 제공할 수 있으면 특히 유용
    - 데이터베이스의 변경사항을 검색 색인에 꾸준히 반영할 수 있다

#### 변경 데이터 캡처의 구현

- 변경 사항을 캡처할 데이터베이스 하나를 리더로 하고 나머지를 팔로워로 한다.
- 로그 기반 메시지 브로커는 메시지 순서를 유지하기 때문에 변경 이벤트를 전송하기에 특히 유용하다.
- 비동기 방식으로 적용되며 커밋할 때까지 기다리지 않는다.
- 느린 소비자가 추가되어도 레코드 시스템에 미치는 영향이 적지만 복제 지연의 모든 문제가 발생하는 단점이 있다.

#### 초기 스냅숏

- 모든 변경사항을 영구적으로 보관하는 일은 디스크 공간이 너무 많이 필요하고 로그 재생 작업도 너무 오래 걸리기 때문에 로그를 적당히 잘라야 한다. = 스냅숏
- 스냅숏 이후 변경 사항을 적용할 시점을 알기 위해 변경 로그의 위치나 오프셋에 대응되야 한다.

#### 로그 컴팩션

- 주기적으로 같은 키의 로그 레코드를 찾아 중복을 제거하고 각 키에 대해 가장 최근에 갱신된 내용만 유지한다.
- 최신값만 데이터베이스 재구축에 사용함으로써, 원본 데이터베이스의 스냅숏을 만들지 않고도 콘텐츠 전체의 복사본을 얻을 수 있다.

#### 변경 스트림용 API 지원

- 

### 이벤트 소싱

- 도메인 주도 설계([[Domain Driven Design]]) 커뮤니티에서 개발한 기법
- 애플리케이션의 상태 변화를 모두 변경 이벤트 로그로 저장
- 애플리케이션 관점에서 사용자의 행동을 불변 이벤트로 기록하는 방식은 데이터 모델링에 쓸 수 있는 강력한 기법이다.

#### 이벤트 로그에서 현재 상태 파생하기

- 모든 이벤트를 영원히 저장하고 필요할 때마다 재처리가 가능해야 한다.

#### 명령과 이벤트

- 사용자 요청이 처음 도착했을 때 이 요청은 **명령**이다.
- 명령이 승인되면 명령은 지속성 있는 불변 **이벤트**가 된다.
- 이벤트는 생성 시점에 **사실(fact)** 이 된다.
- 이벤트를 받은 시점에는 이미 불변 로그의 일부분이므로, 명령의 유효성은 이벤트가 되기 전에 동기식으로 검증해야 한다.
- 가예약 이벤트, 유효한 예약에 대한 확정 이벤트 처럼 분리하는 방식으로 유효성 검사를 비동기로 수행할 수 있다.

### 상태와 스트림 그리고 불변성

> 불변의 중요성

- 불변성 원리는 이벤트 소싱과 데이터 캡쳐를 매우 강력하게 만드는 원칙이다.
- **상태**는 시간이 흐름에 따라 변한 이벤트의 마지막 결과

#### 불변 이벤트의 장점

- 데이터베이스에서 불변성을 이용하는 아이디어는 오래된 아이디어
    - 거래 트랜잭션이 발생하면 거래 정보를 원장에 추가만 하는 방식이 한가지 예
    - 실수가 발생해도 원장은 고치지 않고 실수를 보완하는 거래 내역을 추가한다
    - 잘못된 거래 내역이라도 영원히 남김으로써 회계 감사 등을 위한 정보로 활용한다.
- 불변은 문제 상황의 진단과 복구를 쉽게 한다.
- 불변 이벤트는 현재 상태보다 훨씬 많은 정보를 포함한다.
    - 장바구니에 항목 하나를 넣었다가 제거한 경우, 개별 이벤트는 별 의미가 없을 수 있지만 분석가에게는 매우 중요한 의미를 나타낼 수 있다.

#### 동일한 이벤트 로그로 여러 가지 뷰 만들기

- 흠..

#### 동시성 제어

- 이벤트 로그의 소비가 대개 비동기적으로 이뤄짐으로써, 읽기 일관성 속성이 깨질 수 있다.
- ? 이벤트 로그로 현재 상태를 만들면 동시성 제어 측면이 단순해진다.

#### 불변성의 한계

- 대부분이 데이터를 추가하는 작업이고 갱신이나 삭제는 드물게 발생한다면 불변으로 만들기 쉽다.
- 컴팩션과 가비지 컬렉션의 성능 문제
- 관리상의 이유로 데이터를 진짜로 삭제해야하는 상황이 있을 수 있다.
    - 개인정보 보호법, 사생활 침해 규제 등
    - 히스토리를 새로 쓰고 데이터를 처음부터 기록하지 않았던 것처럼 하는 것 = 적출(exicision) 이라고 하는 개념이 있다.
- 진짜로 삭제하는 것은 놀라울 정도로 어렵다.
    - 많은 곳에 복제본이 남아있기 때문이고 디스크 레벨에서도 그렇다.
    - 삭제는 "찾기 어렵게" 하는 것에 가깝다.

## 스트림 처리

스트림으로 할 수 있는 일에 대해 설명한다.

- 일괄 처리와 스트림이 다른 점은 **스트림은 끝나지 않는다**는 점
    - 이 점은 많은 부분을 어렵게 한다.

### 스트림 처리의 사용

#### 복잡한 이벤트 처리

#### 스트림 분석

- 대량의 이벤트를 집계하고 통계적 지표를 뽑는 것
- 집계 시간 간격을 윈도우(window)라고 한다.

#### 구체화 뷰 유지하기

- 데이터 웨어하우스 등의 파생 데이터 시스템이 원본 데이터베이스의 최신 내용을 따라잡게 하는데 쓸 수 있다.

#### 스트림 상에서 검색하기

- 질의를 먼저 저장하고 메시지는 질의를 지나가면서 실행된다.
- 키워드 알람 등의 구현에 활용된다.

#### 메시지 전달과 RPC

### 시간에 관한 추론

#### 이벤트 시간 대 처리 시간

- 네트워크 문제로 실제로 이벤트가 발생한 시간이 메시지 브로커에 이벤트가 전달되는 시간 순서를 보장해주지 못할 수 있다.

#### 준비 여부 인식

- 

#### 어쨌든 어떤 시계를 사용할 것인가?

- 이벤트가 발생한 시간. 장치 시계를 따른다.
- 이벤트를 서버로 보낸 시간. 장치 시계를 따른다.
- 서버에서 이벤트를 받은 시간. 서버 시계를 따른다.

3가지 시간을 함께 로그로 남겨서 잘못된 장치 시계를 조정할 수 있다.

#### 윈도우 유형

- 텀블링 윈도우
- 홉핑 윈도우
- 슬라이딩 윈도우
- 세션 윈도우

### 스트림 조인

#### 스트림 스트림 조인

#### 스트림 테이블 조인

#### 테이블 테이블 조인

#### 조인의 시간 의존성

### 내결함성

#### 마이크로 일괄 처리와 체크 포인트

- 스트림을 작은 블록으로 나누고 각 블록을 소형 일괄 처리와 같이 다루는 방법

#### 원자적 커밋 재검토

#### 멱등성

#### 실패 후에 상태 재구축하기

## 정리
