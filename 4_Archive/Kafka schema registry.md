---
title: Kafka schema registry
date: 2025-05-29T10:49:14+09:00
aliases: 
tags:
  - kafka
  - schema
description: Kafka schema 를 관리하는 방법인 schema registry 에 대해 설명합니다
updated: 2025-06-08T15:55
published: 2025-06-08
---

> [!info] Sample code
> [GitHub - songkg7/kafka-schema-registry-demo](https://github.com/songkg7/kafka-schema-registry-demo)

## Problems

- 메세지 스펙이 변경될 경우, 의존하고 있는 모듈 or Git Repository 마다 DTO 업데이트가 필요하다.
    - 하위호환성이나 상위호환성이 자주 깨진다.
    - DTO 관리의 복잡도가 선형적으로 증가한다.
    - Java 는 특히 Json 기반의 메세지를 다루기에 불편한 점이 많다.
- 카프카는 `ByteArray` 형태로 메세지를 전송하나, 애플리케이션 레벨에서는 이를 역직렬화하여 관리하는 것이 권장된다.
    - payload 에 데이터를 담을 때마다 `ByteArray` 로 직렬화하는 과정, 그리고 이 반대 과정이 매번 이루어진다.
    - 코드 복잡도 상승
    - ByteArray <-> JSON <-> Object

## ByteArray + DTO + ObjectMapper 방식

Kafka 메시지가 JSON 형식이라고 가정:

```kotlin
data class User(
    val id: String,
    val name: String,
    val email: String?,
    val age: Int?,
    val createdAt: Long
)

val rawBytes: ByteArray = record.value()
val user = objectMapper.readValue(rawBytes, User::class.java)
```

### 특징

- **스키마 정보를 코드에서 직접 관리** (e.g. DTO 클래스)
- Kafka 메시지의 구조가 **JSON 포맷**으로 되어 있어야 가능
- **Schema Registry 불필요**
- 메시지 구조가 바뀌면 DTO도 바뀌어야 하고, **호환성 검사 수동**

## GenericRecord (Avro + Schema Registry)

```kotlin
val record = consumerRecord.value() as GenericRecord
val name = record.get("name").toString()
```

### 특징

- DTO 없이도 동작 가능 (`GenericRecord`), 또는 generated class 사용 가능
- 메시지 구조 변경 시 Registry의 호환성 정책으로 안전하게 진화 가능

## SpecificRecord (Avro + Schema Registry)

```avro
// user.avsc
{
  "type": "record",
  "name": "User",
  "fields": [...]
}
```

```java
// 자동 생성
public class User extends SpecificRecordBase implements SpecificRecord {
    private String id;
    private String name;
    ...
}
```

```kotlin
@KafkaListener(topics = ["\${kafka.topic.user}"], groupId = "\${spring.kafka.consumer.group-id}")
fun consume(user: User) {
    val userId = user.getId()
    logger.info("Received user with id: {}, name: {}", userId, user.getName())
    
    users[userId] = user
}
```

코드가 생성되어있기 때문에 직접 참조 가능

- 정적 타입 지원
    - 직렬화/역직렬화 시 안정성 보장
    - IDE 지원 우수
- Kafka Schema Registry와 완전 호환
- 성능 우수
    - GenericRecord 는 리플렉션을 활용하여 비교적 느림

## Schema 정의 및 사용

- [[IntelliJ]] Junie 를 사용해서 샘플 작성

```kotlin
plugins {
    id("com.github.davidmc24.gradle.plugin.avro") version "1.9.1"
}

repositories {
    mavenCentral()
    maven {
        url = uri("https://packages.confluent.io/maven/")
    }
}

dependencies {
    // Avro and Schema Registry
    implementation("org.apache.avro:avro:1.11.3")
    implementation("io.confluent:kafka-avro-serializer:7.5.1")
    implementation("io.confluent:kafka-schema-registry-client:7.5.1")
}

avro {
    isCreateSetters.set(true)
    isCreateOptionalGetters.set(false)
    isGettersReturnOptional.set(false)
    fieldVisibility.set("PRIVATE")
    outputCharacterEncoding.set("UTF-8")
    stringType.set("String")
    templateDirectory.set(null as String?)
    isEnableDecimalLogicalType.set(true)
}
```

User schema 정의

```avro
{
  "namespace": "com.haril.kafkaschemaregistrydemo.schema",
  "type": "record",
  "name": "User",
  "fields": [
    {
      "name": "id",
      "type": "string"
    },
    {
      "name": "name",
      "type": "string"
    },
    {
      "name": "email",
      "type": ["null", "string"],
      "default": null
    },
    {
      "name": "age",
      "type": ["null", "int"],
      "default": null
    },
    {
      "name": "createdAt",
      "type": {
        "type": "long",
        "logicalType": "timestamp-millis"
      }
    }
  ]
}
```

자동으로 `User` 클래스가 생성된 것을 확인할 수 있고,

![](https://i.imgur.com/JlYqpIE.png)

![](https://i.imgur.com/ZoROVtp.png)

다른 모듈에서 참조하여 사용할 수 있다.

## Schema 의 업데이트

- 레지스트리에 스키마 정보가 없을 경우, kafka 는 메세지가 발행될 때 연결된 schema registry 에 스키마를 업로드한다.
- Web UI 를 사용하여 업데이트할수도 있다.

## Schema 호환성 정책

대표적으로는 아래와 같다.

| 모드         | 설명                            | 예시                       |
| ---------- | ----------------------------- | ------------------------ |
| `BACKWARD` | 이전 버전의 Consumer는 새 메시지를 이해 가능 | 필드 추가 가능, 제거는 불가         |
| `FORWARD`  | 새 버전의 Consumer는 이전 메시지를 이해 가능 | 필드 제거 가능, 추가는 불가         |
| `FULL`     | 양방향 모두 호환                     | 제한적 변경만 허용               |
| `NONE`<br> | 어떤 변경도 호환성 보장 안 함             | 변경 시 consumer crash 위험 ↑ |

`BACKWARD` 정책을 사용할 때는 **스키마에 필드를 추가할 때 default 값을 지정**해줘야 예전 버전의 스키마를 사용하는 Consumer 도 안전하게 스키마를 역직렬화할 수 있다. `null` 을 default 로 지정하는 것도 가능하며 이 경우 optional 필드임을 의미하게 된다.

> [!WARNING] Kafka Streams 는 BACKWARD 만 지원한다.
> `FULL` 정책은 양방향 호환성이 유지되므로 편리하지만 Kafka Streams 는 `BACKWARD` 정책만 지원하므로 선택지가 제한된다.

만약 `GenericRecord` 방식으로 사용할 경우, 스키마를 동적으로 로드한다. 이 경우 스키마가 변경되더라도 서비스의 재배포가 필요없다.

```java
ConsumerRecord<String, GenericRecord> record = ...
GenericRecord value = record.value();

Integer age = (Integer) value.get("age");
String name = value.get("name").toString();
```

`props.put("specific.avro.reader", false)` 설정으로 활성화할 수 있으며, `Map` 으로 사용하는 것과 비슷한 경험을 제공할 수도 있다.

| 항목    | `SpecificRecord`                | `GenericRecord`       |
| ----- | ------------------------------- | --------------------- |
| 사용 방식 | Avro 스키마로 Java/Kotlin 클래스 미리 생성 | 런타임에 스키마 파싱 후 동적으로 사용 |
| 성능    | 빠르고 타입 안전                       | 약간 느리고 타입 안정성 떨어짐     |
| 유연성   | 스키마 변경 시 코드 재생성 필요              | 스키마 변경에도 유연하게 대응 가능   |
| 권장 상황 | 스키마가 고정된 서비스                    | 스키마가 자주 바뀌거나 다양할 때    |

다음과 같은 사용이라면 GenericRecord 사용을 고려할 수 있다.

- 다양한 스키마를 처리해야 하는 **Kafka consumer 플랫폼**
- **스키마 registry 기반 멀티팀 환경** (스키마 버전이 자주 바뀌는 경우)
- **Avro 스키마가 외부에 의해 관리**되고 있어 내부에서 클래스를 만들기 곤란할 때

Producer 에서는 명확한 데이터 스키마가 있어야하므로 `.avsc` 파일을 통해 객체를 생성하고, Consumer 쪽에서는 `GenericRecord` 를 사용하여 동적으로 대응하는 방법도 유용하다.

## Schema management and Monitoring

> Landoop UI

![](https://i.imgur.com/Vkygcbi.png)

스키마 변경 내역을 계속 기록한다.

![](https://i.imgur.com/ZN44eb3.png)

Kafka UI 에서는 value 가 schema registry 로 변경된 것을 확인할 수 있다.

![](https://i.imgur.com/kEtXwQU.png)

## Conclusion

### Pros

- 여러개의 중첩된 DTO 를 다루는 대신, 하나의 avsc 파일만 관리하면 되서 비교적 관리 부담이 줄어든다.
- 모든 서비스는 **Schema Registry에서 실시간으로 스키마 조회**
    - 메시지에 스키마 정보가 포함되지 않으므로, 네트워크 대역폭을 효율적으로 사용하게 된다
- Kafka 메시지는 **스키마 ID (magic byte + schema ID)** 를 포함하므로, 컨슈머는 로컬에 `.avsc`가 없어도 자동 역직렬화 가능
- 여러 팀에서 하나의 스트림 파이프라인 or 토픽에 메세지를 발행하는 경우 특히 유용
    - 파이프라인에 이상한 데이터가 들어오지 않게 된다

### Cons

- 별도 API 서버를 통해 배포해야 한다.
- 인프라 팀과 협업이 필요하다.
    - [AWS Glue Schema Registry](https://docs.aws.amazon.com/ko_kr/glue/latest/dg/schema-registry-integrations.html) 와 같은 인프라 레이어를 설정해야 한다.
- Schema registry 가 다운될 경우 파이프라인이 멈출 수 있기 때문에, 관리 포인트가 오히려 증가할 수 도 있다.

### 그래서 언제 쓰면 좋을까?

- 프로젝트 초기여서 설정부터 하는 경우
- 하나의 파이프라인을 여러 팀이 공유하여 사용하는 경우
- 회사에 카프카를 전문적으로 다루는 별도의 팀이 있을 경우
- protobuf 에 익숙한 경우

## Question

> [!question] ByteArray 로 관리했을 때와 비교하여 유연함이 떨어지지 않나?
> 오히려 타입 안정성이 강화되고 불필요한 직렬화/역직렬화 과정을 없앨 수 있다. IDE 레벨에서 코드 추론을 하기에도 이점이 있다고 생각된다. GenericRecord 로 관리하면 유연하긴 하지만, 유연함은 곧 런타임 에러를 의미한다.

> [!question] To Naver DE. ByteArray, Schema registry 두 가지 방식 다 실제로 써보셨다고 하셨는데, 어떠셨나요?
> 압도적으로 편리까지는 아니지만, 분명히 Schema registry 가 편리하긴 하다. 스키마 관리가 중앙집중 형태로 전환되면 코드 작성시 번거로움이 많이 줄어든다. 반면 모니터링해야할 요소가 하나 추가되어 다른 관점의 복잡도가 증가하는 것이다. 즉, '서비스 별로 DTO 계속 중복 생성하면서 관리할래? vs 중앙에 두는 대신 지속적으로 모니터링 할래?' 의 트레이드오프.
>
> 보통 이런 류의 모니터링은 큰 회사에서는 인프라 분들이 해주시거나, 별도의 팀이 있기 때문에 서비스 개발자 입장에서는 후자가 나을 수 있겠다. 그걸 직접 해야하는 환경이라면 팀내에서 많이 의논해보시길 바람.

> [!question] 스키마에 새로운 필드가 추가될 경우, 직접적인 연관이 없는 프로듀서, 컨슈머 애플리케이션의 코드 변경이 필요한가?
> BACKWARD 정책을 사용할 경우에는, 코드 변경이 전혀 필요없다. 계속 기존 avsc 파일로 생성된 코드를 기반으로 메세지를 발행하고 소비할 수 있다. 새로 추가된 필드를 다른 프로듀서나 컨슈머에서 참조해야할 경우에만, Schema registry 에서 avsc 파일을 가져와서 코드를 재생성하면 된다.

## Reference

- [Confluent Schema Registry 도입기!. Schema Registry 도입을 위한 PoC 여정을 소개합니다! \| by Suyeon Kim \| YOGIYO Tech Blog - 요기요 기술블로그](https://techblog.yogiyo.co.kr/confluent-schema-registry-%EB%8F%84%EC%9E%85%EA%B8%B0-54d112b9b53f)
- [Kafka 와 Confluent Schema Registry 를 사용한 스키마 관리 #1](https://medium.com/@gaemi/kafka-%EC%99%80-confluent-schema-registry-%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-%EC%8A%A4%ED%82%A4%EB%A7%88-%EA%B4%80%EB%A6%AC-1-cdf8c99d2c5c)
- [Kafka 와 Confluent Schema Registry 를 사용한 스키마 관리 #2](https://medium.com/@gaemi/kafka-%EC%99%80-confluent-schema-registry-%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-%EC%8A%A4%ED%82%A4%EB%A7%88-%EA%B4%80%EB%A6%AC-2-bfa96622a974)
- [Kafka 와 Confluent Schema Registry 를 사용한 스키마 관리 #3](https://medium.com/@gaemi/kafka-%EC%99%80-confluent-schema-registry-%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-%EC%8A%A4%ED%82%A4%EB%A7%88-%EA%B4%80%EB%A6%AC-3-96b0f070d0f1)
- [Kafka with Schema Registry and Avro Serialization](https://howtodoinjava.com/kafka/kafka-with-avro-and-schema-registry/?utm_source=chatgpt.com)
- [Kafka Schema Registry and JSON Schema: A Comprehensive Guide \| Pravin on Software](https://pravin.dev/posts/kafka-schema-registry-and-json-schema-a-comprehensive-guide/?utm_source=chatgpt.com)
- [\[번역\] 에이브로(Avro), 프로토콜 버퍼(Protocol Buffers) 그리고 스리프트(Thrift)의 스키마 변경(evolution) \| 커피한잔의 여유와 코딩](http://sjava.net/2012/12/%EB%B2%88%EC%97%AD-%EC%97%90%EC%9D%B4%EB%B8%8C%EB%A1%9Cavro-%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C-%EB%B2%84%ED%8D%BCprotocol-buffers-%EC%93%B0%EB%A6%AC%ED%94%84%ED%8A%B8thrift%EC%9D%98-%EC%8A%A4/)
