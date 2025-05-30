---
title: Entity 의 ID 로 적절한 타입은 무엇일까?
date: 2022-10-24T17:08:00
aliases: 
tags:
  - entity
  - id
  - ulid
  - uuid
  - long
categories: 
updated: 2025-02-16T23:26
---

## Overview

[[Spring Data JPA]] 를 사용하다보면 Entity 를 작성해야하는 일이 잦습니다. Entity 는 곧 DB 의 table 이 되기 때문에 PK가 될 `ID` 를 정해줘야 하는데 이 글에서는 어떤 type 이 ID 로서 적절한지에 대해 적어보려고 합니다.

## Contents

### Long

가장 대중적으로 사용되는 타입이다. 32bit 인 int 에 비해서 훨씬 큰 값까지 표현할 수 있기 때문에 ID 로 사용하기에 손색이 없다.

> [!NOTE] int
> 약 41억까지 표현할 수 있다. 음수를 제외하면 20억 남짓인데, 대량의 데이터를 처리하기엔 아무래도 작은 숫자이기 때문에 테이블의 Id type 으로는 적절하지 않다.

[Spoqa 기술블로그](https://spoqa.github.io/2022/08/16/kotlin-jpa-entity.html) 에선

> `Long` 타입의 Primary Key는 유일성을 보장하는 데 한계가 있기 때문입니다. Entity끼리도 키값이 중복될 수도 있고 `UUID`의 개수보다 `Long` 타입의 개수가 현저하게 적기 때문에 최대 개수에 대해 걱정을 하지 않고 싶다면 `UUID`는 좋은 선택이 될 것입니다.

라고 언급한다. 하지만 조금 의아한 부분이 몇가지 있다. 왜 그런지 하나씩 짚어보자.

`Long` 타입 은 유일성을 보장하는데 한계가 있다. 하지만 중요한건 그 한계가 어마어마하게 크다는 것이다. Long 타입이 표현할 수 있는 최댓값은 2^64 인데, `18,446,744,073,709,600,000` 이다. 음수는 제외한다고 해도 `9,223,372,036,854,780,000` 범위를 표현할 수 있다. 얼마나 큰 값인지 와닿지 않을 수 있겠다. 이 범위를 초과하려면 **하루에 10억건의 데이터를 생성한다고 했을 때 약 2500만년**이 걸린다. 샤딩이나 클러스터링은 둘 째치고 테이블마다 별도의 아이디 생성 전략을 사용할 수 있는건 아직 고려하지도 않았다.

아직도 `Long` 타입에 최대 개수 걱정이 필요하다고 느껴지는가?

또 다른 경우를 보자.

JPA 의 `GenerateValue` 를 사용할 경우, 아이디 채번을 위해 insert 전 DB 조회 쿼리가 한 번 발생하게 된다. 만약 100개의 entity 를 insert 해야한다면 200번의 쿼리가 발생하는 것이다. 저장해야하는 entity 의 개수가 많다면 이 조회 쿼리는 낭비가 될 수 있는데, 이럴 경우는 아이디를 애플리케이션 내부에서 미리 생성하여 조회 쿼리를 막을 수 있다.

Long 타입이 어려워지는건 분산된 환경에서의 아이디 생성 전략이 필요해질 경우, 매우 많은 트래픽 발생으로 인해 명확하게 DB 퍼포먼스에 저하가 발생하는 경우이다. 그럼 이럴 때 어떤 전략을 선택할 수 있을까?

### UUID

Long 타입 아이디 생성을 위해서는 DB sequence 가 많이 이용된다. 이 방법은 아이디 생성 전 DB 를 먼저 조회하여 생성될 아이디를 결정하는 방식이라 트래픽이 늘어난다면 DB 에 부담이 되게 된다. 따라서 DB 조회가 필요없는 ID 생성 전략이 필요해졌고 그 해결 방법으로 UUID 가 종종 고려되곤 한다.

UUID 는 각 서버별로 직접 생성할 수 있어서 확장성이 매우 뛰어나다.

`UUID` 는 `Universal Unique Id` 인만큼 전 우주에서 유일한 값이라는 걸 보장한다. 그런만큼 ID 로 사용하기에는 최적처럼 보인다.

하지만 `UUID` 는 ID 가 언제 생성되었는지에 대한 정보를 담지 않기 때문에 ID 로 정렬해도 시간순 정렬되지 않는다. PK 는 정렬된 상태로 인덱스가 생성되는 것을 감안해볼 때 아쉬운 점이다.

아이디에 의미를 부여하지 못하는 것도 아쉬움 중 하나이다.

128비트로 비교적 길다. (long = 64 bit, int = 32bit)

#### UUIDv7

UUID 를 시간순으로 생성하고자 하는 시도가 최근에 있었다.

### ULID

ULID(Universally Unique Lexicographically Sortable Identifier)는 대소문자를 구별하지 않는 시간을 나타내는 26자 글자와 16글자의 임의의 값으로 구성되어 있다.

앞부분이 Timestamp 를 나타내므로 정렬이 가능하다.

ULID 는 UUID 의 단점을 극복하기 위해 등장했다.

### Snowflake

[[Snowflake]]

트위터에서 제안한 분산 아이디 생성 전략이다. 64bit 로 이루어져 있고 각 구간이 다른 의미를 지닌다. 애플리케이션 내부에서 자체적으로 생성할 수 있으며, 따라서 아이디 티켓 서버가 필요하지 않다.

- 비교적 짧은 길이를 가진다
- 만들 수 있는 최대 시간폭이 정해져있기에(bit 할당에 따라 다르지만 약 70년), 마이그레이션 전략이 필요할 수 있다

### H3



## Conclusion

## Reference

- [ULID](https://github.com/ulid/spec)
- [UUID vs ULID](https://velog.io/@injoon2019/UUID-vs-ULID)
- [Discord Documentation](https://discord.com/developers/docs/reference#snowflakes)
