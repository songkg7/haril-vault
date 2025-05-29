---
title: Kafka schema registry
date: 2025-05-29T10:49:14+09:00
aliases: 
tags:
  - kafka
  - schema
description: 
updated: 2025-05-29T18:09
---

## Problems

- CP 추가 등으로 인해 스트림에 흐를 메세지 스펙이 변경될 경우, 의존하고 있는 모듈 or Git Repository 마다 DTO 업데이트가 필요하다.
    - 하위호환성이나 상위호환성이 자주 깨진다.
    - DTO 관리의 복잡도가 선형적으로 증가한다.
- 카프카는 `ByteArray` 형태로 메세지를 전송하나, 애플리케이션 레벨에서는 이를 역직렬화하여 관리하는 것이 권장된다.
    - payload 에 데이터를 담을 때마다 `ByteArray` 로 직렬화하는 과정, 그리고 이 반대 과정이 매번 이루어진다.

## Experiment

[GitHub - songkg7/kafka-schema-registry-demo](https://github.com/songkg7/kafka-schema-registry-demo)

### Schema 정의 및 사용

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

### Schema 의 업데이트

- 레지스트리에 스키마 정보가 없을 경우, kafka 는 메세지가 발행될 때 연결된 schema registry 에 스키마를 업로드한다.
- 

### Schema 호환성 정책

| 모드         | 설명                            | 예시                       |
| ---------- | ----------------------------- | ------------------------ |
| `BACKWARD` | 이전 버전의 Consumer는 새 메시지를 이해 가능 | 필드 추가 가능, 제거는 불가         |
| `FORWARD`  | 새 버전의 Consumer는 이전 메시지를 이해 가능 | 필드 제거 가능, 추가는 불가         |
| `FULL`     | 양방향 모두 호환                     | 제한적 변경만 허용               |
| `NONE`<br> | 어떤 변경도 호환성 보장 안 함             | 변경 시 consumer crash 위험 ↑ |

BACKWARD 정책을 사용할 경우, 새로운 필드가 추가될 때 이전 버전의 스키마는 최신화가 필요하지 않다. 즉, 재배포가 필요하지 않고 새로운 코드 작성에만 집중할 수 있다. 이는 Avro + Schema registry 를 쓰는 장점 중 하나다.

만약 `GenericRecord` 방식으로 사용할 경우, 스키마를 동적으로 로드한다. 이 경우 스키마가 변경되더라도 서비스의 재배포가 필요없다.

```java
ConsumerRecord<String, GenericRecord> record = ...
GenericRecord value = record.value();

Integer cpId = (Integer) value.get("cpId");
String cpPid = value.get("cpPid").toString();
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

### Schema Monitoring

> Landoop UI

![](https://i.imgur.com/Vkygcbi.png)

스키마 변경 내역을 계속 기록한다.

![](https://i.imgur.com/ZN44eb3.png)

Kafka UI 에서는 value 가 schema registry 로 변경된 것을 확인할 수 있다.

![](https://i.imgur.com/kEtXwQU.png)

## Conclusion

### Pros

- 모든 서비스는 **Schema Registry에서 실시간으로 스키마 조회**
- Kafka 메시지는 **스키마 ID (magic byte + schema ID)** 를 포함하므로, 컨슈머는 로컬에 `.avsc`가 없어도 자동 역직렬화 가능
- **공유되는 스키마를 git 에서 별도 복사/정의할 필요 없음**
- 여러 팀에서 하나의 스트림 파이프라인 or 토픽에 메세지를 발행하는 경우 특히 유용
    - 파이프라인에 이상한 데이터가 들어오지 않게 된다

### Cons

- 별도 API 서버를 통해 배포해야 한다.
- 인프라 팀과 협업이 필요하다
    - [AWS Glue Schema Registry](https://docs.aws.amazon.com/ko_kr/glue/latest/dg/schema-registry-integrations.html) 와 같은 인프라 레이어를 설정해야 한다.
- Schema 를 중앙에서 관리하기 위해 별도의 repo 에서 schema 만 관리하고 CI 파이프라인을 설정해야할 수 있음
    - `schema-management`
    - SpecificRecord 로 관리하려면 avro 를 모듈마다 들고 있는 상태에서 코드를 생성해야 한다. 그게 아니라면 avro 를 어디에든 두고 최신화하거나, 참조할 수 있어야 한다.
- Json 형태를 기반으로 코드를 만들어주긴 하지만, 결국 Json 을 들고 있어야 하는게 아닌가?

## Question

> [!question] ByteArray 로 관리했을 때와 비교하여 유연함이 떨어지지 않나?
> 오히려 타입 안정성이 강화되고 불필요한 직렬화/역직렬화 과정을 없앨 수 있다. IDE 레벨에서 코드 추론을 하기에도 이점이 있다고 생각된다. GenericRecord 로 관리하면 유연하긴 하지만, 유연함은 곧 런타임 에러를 의미한다.

> [!question] To Naver DE. ByteArray, Schema registry 두 가지 방식 다 실제로 써보셨다고 하셨는데, 어떠셨나요?
> 압도적으로 편리까지는 아니지만, 분명히 Schema registry 가 편리하긴 하다. 스키마 관리가 중앙집중 형태로 전환되면 코드 작성시 번거로움이 많이 줄어든다.
