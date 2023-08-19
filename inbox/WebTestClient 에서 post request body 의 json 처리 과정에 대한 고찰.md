---
title: WebTestClient 에서 post request body 테스트
date: 2022-10-19 18:40:00 +0900
aliases: null
tags:
  - kotlin
  - kotest
  - webflux
  - webtestclinet
categories: null
updated: 2023-08-19 12:38:10 +0900
---

## Enviroment

- [[Kotlin]]
- [[Spring WebFlux]]

## Problem

실제 동작 시엔 문제없이 잘 되지만, 테스트로 실행하면 발생하는 json serialize 관련 에러

```kotlin
data class CreateMemberCommand(
    val nickname: String,

    val birthday: LocalDate,

    val email: String,
)
```

실제 서버 기동시엔 문제 없이 잘 동작함.

```bash
# 201 Created
http POST localhost:8080/member nickname=test2 email=test birthday=1994-07-07
```

문제는 테스트 코드 작성시에 발생하며, no-args constructor 가 없다는 에러가 출력됨.

### Test

```kotlin
@WebFluxTest
internal class SnsRoutersTest : DescribeSpec() {

    private var memberWriteService = mockk<MemberWriteService>()
    private var memberReadService = mockk<MemberReadService>()
    private lateinit var webTestClient: WebTestClient

    init {
        beforeTest {
            webTestClient = WebTestClient.bindToRouterFunction(
                SnsRouters(
                    MemberHandler(
                        memberWriteService,
                        memberReadService
                    )
                ).memberRouter()
            ).build()
        }

        describe("POST /member") {
            it("returns 201") {

                every { memberWriteService.create(any()) } returns Unit

                webTestClient.post()
                    .uri("/member")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(
                        """
                        {
                            "nickname": "test",
                            "birthday": "1994-07-07",
                            "email": "test@email.com"
                        }
                        """.trimIndent()
                    )
                    .exchange()
                    .expectStatus().isCreated
            }
        } 
    }
}
```

#### Error log

```logs
18:49:32.879 [pool-1-thread-1] ERROR o.s.t.w.r.server.ExchangeResult - Request details for assertion failure:

> POST /member
> WebTestClient-Request-Id: [1]
> Content-Type: [application/json]
> Content-Length: [87]

{
    "nickname": "test",
    "birthday": "1994-07-07",
    "email": "test@email.com"
}

< 400 BAD_REQUEST Bad Request
< Content-Type: [text/plain;charset=UTF-8]
< Content-Length: [518]

Type definition error: [simple type, class com.example.demosns.domain.member.dto.CreateMemberCommand]; nested exception is com.fasterxml.jackson.databind.exc.InvalidDefinitionException: Cannot construct instance of `com.example.demosns.domain.member.dto.CreateMemberCommand` (no Creators, like default constructor, exist): cannot deserialize from Object value (no delegate- or property-based Creator)
 at [Source: (org.springframework.core.io.buffer.DefaultDataBuffer$DefaultDataBufferInputStream); line: 2, column: 5]
```

`LocalDate` 처리를 위해 fasterxml jackson bind jsr310 추가

이미 잘 되던게 `@JsonProperty` 를 추가하자 갑자기 jsr310 의존성을 요구한다.

```gradle
dependencies {
	...
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310")
	...
}

```

## Solution, but...

```kotlin
data class CreateMemberCommand(
    @JsonProperty("nickname")
    val nickname: String,

    @JsonProperty("birthday")
    val birthday: LocalDate,

    @JsonProperty("email")
    val email: String,
) 
```

이 방법은 매우 마음에 들지 않는 해결책

`@JsonNaming` 이 동작하지 않음

모든 필드에 `@JsonProperty` 를 붙여야 함. 아무리 presentation 객체라지만 너무 지저분해짐.

## Next step
