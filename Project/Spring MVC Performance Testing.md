---
title: Spring MVC Performance Testing
date: 2023-11-06 10:33:00 +0900
aliases: 
tags:
  - test
  - k6
  - aws
  - stress-test
  - spike-test
  - performance-test
categories: 
updated: 2023-11-09 18:13:34 +0900
---

## Goals

> [[Spring MVC]] 웹 애플리케이션은 동시 사용자를 몇 명까지 처리할 수 있을까? 🤔

- $ Spring MVC 의 최대 트래픽 처리량 확인
- AWS EC2 에 IAM 을 사용한 로그인 방법 학습
- AWS ECR 을 활용한 애플리케이션 배포의 기본적인 워크플로우 학습

이상의 3가지 기본 사용법을 학습하여 이후 환경이 어떻게 변하더라도 대응할 수 있도록 하는 것을 목표로 한다.

## Enviroment

- SpringBoot 3.x
- [[Spring MVC]]
- [[Spring Actuator]]
- EC2 t4g.small (Amazon Linux 2core 2GB 64bit ARM) 1대
- [[AWS ECR]]
- [[K6]]

## Test Scenario

- 동시에 200명 이상의 사용자가 API 를 요청하는 상황을 가정
- 해당 API 가 너무 빨리 응답하는 것을 방지하고, 어느 정도의 지연을 모의하기 위해 5초의 대기시간을 갖도록 구현
- Spring MVC 의 tomcat 설정을 조절해가면서 트래픽 처리량을 검증
- 테스트 데이터의 오염을 방지하기 위해 API 는 EC2 에 배포해놓은 상태에서, 로컬에서 부하를 발생

## Test Application

1. 테스트에 사용할 애플리케이션 구현
2. 도커 이미지 빌드
3. EC2 생성
4. EC2 에 SSM 접근하기 위한 IAM role 생성
5. ECR public repository 에 2번의 이미지를 push << 현재 단계
6. 3번의 EC2 에서 도커 이미지 실행 (배포 완료)
7. 부하테스트를 위한 K6 스크립트 작성 및 실행

먼저 API 를 간단하게 구현한다.

```java
@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() throws InterruptedException {
        TimeUnit.SECONDS.sleep(5); // 처리 시간을 시뮬레이션
        return "Hello, World!";
    }
}
```

어느 정도 오버로드가 발생하는 API 라고 가정하기 위해 1초의 지연 시간을 주었다.

조절할 설정은 다음과 같다.

```yaml
server:
  tomcat:
    threads:
      max: 200                # 생성할 수 있는 thread의 총 개수
      min-spare: 10           # 항상 활성화 되어있는(idle) thread의 개수
    max-connections: 8192     # 수립가능한 connection의 총 개수
    accept-count: 100         # 작업큐의 사이즈
    connection-timeout: 20000 # timeout 판단 기준 시간, 20초
```

서버에서의 원활한 설정값 수정을 위해 모든 부분을 시스템 환경변수로 대체한다.

```yaml
server:
  tomcat:
    threads:
      max: ${TOMCAT_MAX_THREADS:200}
      min-spare: ${TOMCAT_MIN_SPARE:10}
    max-connections: ${TOMCAT_MAX_CONNECTIONS:8192}
    accept-count: ${TOMCAT_ACCEPT_COUNT:100}
    connection-timeout: ${TOMCAT_CONNECTION_TIMEOUT:20000}
```

[[Docker Image]] 를 빌드하기 위해 [[Dockerfile]] 을 작성한다.

```dockerfile
# java 17 multi stage build
FROM gradle:8.4.0-jdk17 as builder
WORKDIR /app
COPY . .
RUN gradle clean build

FROM openjdk:17-ea-11-jdk-slim
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```bash
docker build -t sample-server .
```

이대로라면 이미지의 identify 가 지정되지 않아 image 를 push 할 수 없다. ECR 을 이미지 저장소로 사용하기 위해서는 ECR 의 identify 를 지정해야하는데, 아직 설정하지 않았으니 관련 infra 설정을 간략하게 살펴보자.

## Infrastructure

테스트 대상 서버가 로컬 서버 환경에 영향을 받는 것을 피하기 위해 별도의 서버 설정을 진행했다.

1. EC2 인스턴스 생성
2. 보안그룹 생성
3. 인바운드 정책을 생성하여 public IP 로 접근가능하도록 설정, my IP 옵션 추천
4. IAM role 을 생성하여 EC2 인스턴스에 부여 (Optional)

> [!info]
> 이 정도만 해둬도 테스트 진행에는 무리가 없을 것이라 생각합니다. 이번 글의 주제는 인프라 구성이 아니므로, 자세한 내용은 다른 포스트에서 다뤄봅니다.

## K6

[[K6]] 는 [[Grafana]] Lab 에서 만든 부하테스트 툴이다.

### K6 설치

```bash
brew install k6
```

### 모니터링 구성

[[Grafana]] 와 [[InfluxDB]] 를 설치해준다. 도커 컴포즈로 간편하게 구성한다.

```yaml
version: "3.7"

services:
  influxdb:
    image: bitnami/influxdb:1.8.5
    container_name: influxdb
    ports:
      - "8086:8086"
      - "8085:8088"
    environment:
      - INFLUXDB_ADMIN_USER_PASSWORD=bitnami123
      - INFLUXDB_ADMIN_USER_TOKEN=admintoken123
      - INFLUXDB_HTTP_AUTH_ENABLED=false
      - INFLUXDB_DB=myk6db
  granafa:
    image: bitnami/grafana:latest
    ports:
      - "3000:3000"
```

influxDB 가 정상동작하는지 확인해보자. 만약 아래 명령어가 실행되지 않는다면, `brew install influxdb-cli` 를 통해 커맨드를 먼저 설치해줘야 한다.

```bash
influx ping
# OK
```

http://localhost:3000 으로 접근하여 그라파나가 정상적으로 동작하는 것을 확인한다.

![[Pasted image 20231108094916.png]]

> [!info]
> Grafana 의 초기 계정정보는 아이디와 비밀번호 모두 admin 을 입력하면 된다. 비밀번호를 변경하라고 나오겠지만, 이번에 그라파나를 사용하는 이유는 운영이 아니라 테스트이므로 skip 해도 무방할 것이다.

### Script 작성

스파이크 테스트를 수행하기 위해서 아래와 같은 스크립트를 작성해주었다.

```js
import http from 'k6/http';
import { check } from 'k6';

export const options = {
    scenarios: {
        spike: {
            executor: 'constant-vus',
            vus: 300,
            duration: '5s',
        },
    },
};

export default function () {
    const res = http.get('http://54.180.78.85/hello');
    check(res, { 'is status 200': (r) => r.status == 200 });
};
```

간단하게 중요한 키워드만 설명해보면,

- `constant-vus`: 테스트 실행 전 고정된 유저를 미리 생성해주는 executor
- `vus`: vertual users 로, 테스트에 사용할 유저 수를 의미한다

### 테스트 실행 및 분석

아래 명령을 실행하면 테스트가 수행된다.

```bash
k6 run --out influxdb=http://localhost:8086/myk6db spike-test.js
```

#### 300 requests

![Imgur](https://i.imgur.com/bVfAhxd.png)

5초 간격으로 200개의 요청이 먼저 처리되고 뒤이어 100개의 나머지 요청이 처리되었다.

- [?] nio http connector 를 사용한다면 기본 스레드풀 개수인 200개보다 많은 숫자를 처리할 수 있을 것이라 예상했는데 그렇지 않은 이유는 무엇일까?

#### 1000 requests

![](https://i.imgur.com/RhJG0Wq.png)

5초 간격으로 요청을 처리하는 것을 확인할 수 있다. 총 처리 시간은 25s 남짓이 걸린다. 가장 빠르게 접근한 사용자는 5.01s 만에 결과를 확인하겠지만, 그렇지 못한 사용자는 25s 를 기다려야 결과를 확인할 수 있다.

이 시점에 기본 톰캣 설정의 `connection-timeout` 인 20s 를 넘었다. 하지만 타임아웃 에러는 발생하지 않았고, 20s 이상을 기다려서라도 모두 처리되었다.

- [?] `connection-timeout` 은 정확히 어떤 타임아웃을 의미할까?

#### 2000 requests

이쯤에서 한 번 고비가 찾아온다.

K6 에서는 일정 시간 이상 실행되는 테스트를 안전하게 중지하는 `gracefulStop`[^1] 기능이 존재한다. 이 기능은 30s 가 기본값으로 설정되어 있어서 **timeout 을 보기 전에 테스트를 중단**시키므로, 스크립트를 좀 수정해서 더 오랜 기간 테스트가 수행되도록 해야 한다.

```js
import http from 'k6/http';
import { check } from 'k6';

export const options = {
    scenarios: {
        spike: {
            executor: 'constant-vus',
            vus: 2000,
            duration: '5s',
            gracefulStop: '5m', // 추가
        },
    },
};

export default function () {
    const res = http.get('http://54.180.78.85/hello');
    check(res, { 'is status 200': (r) => r.status == 200 });
};
```

![](https://i.imgur.com/OegYzyC.png)

- [?] 중간에 사라지는 요청이 1~2개 정도 있을 때가 있다. 단순한 네트워크 에러인가? 왜 그럴까?

#### 3000 requests

#network #timeout

어느 정도 예상됐던 고비가 온다.

![](https://i.imgur.com/rM78o5F.png)

이번에는 요청이 1분이상 대기하게 되면서 request timeout 이 발생한다.

- [?] request timeout 이 1m 이라는 설정은 어디에 있을까?

200 스레드로 3000 개의 요청을 처리하므로, 5초의 대기시간까지 고려해보면 운이 없는 유저의 요청은 $3000 / 200 * 5 = 75(s)$ 를 대기해야 한다. 따라서 타임아웃 회피를 위해서는 15초 이상 시간의 단축이 필요하며, 기본설정으로는 request timeout 을 피하기 어려워보인다. 몇 가지 방법을 생각해볼 수 있을 것 같다.

1. thread pool 의 사이즈를 200 에서 500 정도로 늘리면 동시 처리량이 늘어나면서 해결될 것이다.
2. thread sleep 을 5초에서 조금 줄이는 식으로 처리 속도를 더 빠르게 한다.
3. 타임아웃 시간을 늘려 유저를 더 기다리게 한다.

이번 테스트의 목적을 생각해보면 1번이 가장 적절하다고 판단하기 때문에, 이번에는 thread 개수를 좀 더 늘리도록 하려 한다.

이전에 `application.yml` 에 미리 환경변수를 주입 받을 수 있도록 해뒀던 부분이 기억나실 것이다. 한 번 활용해보자.

```bash
docker run -d -p "80:8080" -e TOMCAT_MAX_THREADS=500 --name sample-server --restart always 123456789012.dkr.ecr.ap-northeast-2.amazonaws.com/sample-server:v1
```

`-e TOMCAT_MAX_THREADS=500` 옵션을 통해서 컨테이너 내부에 환경변수를 넣어줬다. 이 환경변수는 `application.yml` 에 존재하는 자기 자리로 찾아가서 스레드풀 설정을 변화시킨다.

이후 다시 한 번 테스트를 해보면...

![](https://i.imgur.com/IaRf7y3.png)

![](https://i.imgur.com/xLVxU9w.png)

이번에는 타임아웃 없이 처리되는 것을 확인할 수 있다.

서버의 리소스를 이전보다는 쓰게 되겠지만, 처리속도가 월등히 빨라져서 75s 에서 30s 로 줄어들게 되었다. 이런 식으로 스레드만 늘려줘도 성능 개선이 가능한 것을 확인했다.

#### 6000 requests

![](https://i.imgur.com/3dorRSj.png)

스레드 풀을 500 으로 늘렸지만, 6000 requests 부터는 다시 request timeout 이 발생한다. 동시처리량을 더 늘려야할 필요가 있다. 좀 전에 했던 방법처럼 스레드 개수를 더 늘리면 어떨까? 스레드가 너무 많으면 리소스 경합이 발생하므로 그다지 바람직하지 못하지만, 우선 가능할 때까지 스레드를 늘리는 방향으로 생각해보자. 이전과 같은 방식을 사용하여 1000 개로 늘려줬다.

- [?] 스레드는 몇개까지 늘리는게 가능할까?

![](https://i.imgur.com/l7uzhej.png)

_thread pool 1000 에서 다시 성공_

다행히 스레드 1000개 정도는 2core 2GB 의 EC2 성능으로도 충분한 것 같다. resource 사용량도 크게 높아지지 않았으며 안정적이였다.

#### 10k requests

![](https://i.imgur.com/IFYLBPd.png)

- [!] i/o timeout
- [!] request timeout
- [!] cannot allocate memory
- [!] connection reset by peer

- 10k 에서 i/o timeout 이 처음으로 발생했다.
 - 테스트 실행 후 20s 에서 request timeout 이 발생했다. 연관관계는 확실하지 않지만, 20s 는 connection-timeout 과 일치한다.

먼저, 정확한 에러 원인 파악을 위해 테스트 실행 시점에 TCP 연결이 몇 개나 수락되는지 모니터링해봤다. 리눅스에서 소켓 모니터링을 위해 사용할 수 있는 `ss` 명령어를 사용했다.

```bash
# TCP 수 모니터링
watch ss -s
```

![](https://i.imgur.com/LCIm2BW.png)

_closed 가 10k 에 미치지 못한다. 정상적으로 커넥션이 생성되었다면 10k 를 넘었을 것이다._

10k 의 TCP 커넥션을 맺을 수 없는 것을 확인했다. 지금까지는 유저의 수대로 정확하게 TCP 커넥션이 증가하는 것을 확인했는데 처음으로 커넥션 개수가 모자라기 시작했다.

![](https://i.imgur.com/IbJrKrz.png)

정상적으로 종료되지 않은 커넥션이 정리될때까지 약간의 텀을 두고 몇 번을 반복해도 8293 vus 만 성공했다. 왜 그럴까? ~~maxConnections 는 8192... acceptCount 는 100..~~

이 시점에서 몇 가지 생각해볼 수 있는 부분을 정리해보자.

1. `max-connections` 속성은 애플리케이션의 TCP 최대 커넥션 개수와 연관이 있을 것이다.
2. request timeout 은 TCP 연결을 맺지 못한 상태로 20s 가 경과하여 발생한 connection-timeout 에러일 것이다.
3. `accept-count` 속성도 마찬가지로 TCP 최대 커넥션 개수와 연관이 있을 것이다.
4. `max-connections` 을 증가시키면 커넥션을 맺은 상태이기 때문에 connection timeout 을 회피할 수 있다.
5. i/o timeout 이 발생하지 않은 이유는 모든 요청이 정상적으로 처리되었기 때문일 것이다.

이 후 단계는 위 가설을 하나씩 검증해본다. 모든 검증은 기존 동작 중은 컨테이너를 정지 후 새로운 컨테이너를 생성하여 진행했다.

##### 1. Max Connection

먼저 max connection 값을 20k 로 증가시키고 테스트를 실행한다.

![](https://i.imgur.com/7wQDXG6.png)

오호... 이전과는 다르게 커넥션이 10k 를 넘겨서 생성되었다.

![](https://i.imgur.com/ETTdN93.png)

심지어 아무런 에러 없이 성공한다. 이로써 `max-connections` 은 OS 에 생성되는 애플리케이션의 커넥션과 직접적인 관련이 있다고 생각할 수 있다.

1. ~~max-connections 은 애플리케이션의 TCP 최대 커넥션 개수와 연관이 있을 것이다.~~ **관련 있음**

##### 2. Connection Timeout

2번을 명확히 하기 위해서 이번에는 `max-connections` 는 다시 기본값으로 하고, `connection-timeout` 만 30s 로 수정한 후 다시 테스트해본다.

```yaml
max-connections: 8192
connection-timeout: 30000
```

여전히 20s 를 지난 시점에 request timeout 이 발생했다. 그렇다면, `connection-timeout` 은 연결의 시작 시점과는 무관하다고 생각할 수 있다. 사실 이 설정은 클라이언트와 **연결을 맺은 이후 종료할 때까지의 타임아웃**[^2]이다.

2. ~~request timeout 은 TCP 연결을 맺지 못한 상태로 20s 가 경과하여 발생한 connection-timeout 에러일 것이다.~~ **관련 없음**

##### 3. Accept Count

3번을 명확히 하기 위해서 이번에는 `accept-count` 만 늘려보자.

```yaml
max-connections: 8192
accept-count: 2000 # 작업 큐
```

`accept-count` 가 100 일 때 성공한 요청 수는 8293 이였다. 2000 으로 늘리면 10k 이상의 요청을 처리할 수 있을까? 혹은 TCP 연결 수락과 작업 큐가 직접적인 관련은 없을테니 여전히 실패할까? 직접 확인해보자.

![](https://i.imgur.com/9MohYiI.png)

![](https://i.imgur.com/B6aR4Y8.png)

인상적이다. `max-connections` 을 늘리지 않았고 `accept-count` 만 늘려주었는데 10k 이상의 TCP 연결이 수락되었다. 혹시 '설정을 잘못했나?' 싶어서 actuator 를 활용하여 애플리케이션의 설정을 확인해봤지만, 의도한대로 설정된 상태다.

![](https://i.imgur.com/81Rk4Qj.png)

_actuator 는 동작 중인 애플리케이션의 상태를 확인하는데 매우 유용하게 사용할 수 있다_

`accept-count` 는 그저 작업 큐에만 관련된 설정이 아닌걸까? queue 를 좀 늘렸다고 OS connection 카운트가 늘어나다니...?

`ServerProperties` 클래스의 javaDoc 을 보면 이 의문에 대한 힌트를 발견할 수 있다.

```java
/**
 * Maximum number of connections that the server accepts and processes at any
 * given time. Once the limit has been reached, the operating system may still
 * accept connections based on the "acceptCount" property.
 */
private int maxConnections = 8192;

/**
 * Maximum queue length for incoming connection requests when all possible request
 * processing threads are in use.
 */
private int acceptCount = 100;
```

`maxConnections` 필드를 보면 다음과 같은 주석이 있다.

> Once the limit has been reached, the operating system may still accept connections based on the "acceptCount" property (제한에 도달한 뒤에도, 운영체제는 "acceptCount" 속성에 따라 여전히 커넥션을 수락할 수 있습니다.)

즉, 기본 값인 8192 개의 커넥션 제한에 도달하면, acceptCount 의 값만큼 OS 가 추가 커넥션을 수락하게 한다는 내용이다. 8192(thread) + 100(accept) = 8293(connection)[^3] 일 것이라는 기존의 추론을 뒷받침해주는 부분이다.

3. ~~acceptCount 도 마찬가지로 TCP 최대 커넥션 개수와 연관이 있을 것이다.~~ **관련 있음**

##### 그 외

4. `max-connections` 을 증가시키면 커넥션을 맺은 상태이기 때문에 connection timeout 을 회피할 수 있다.
5. i/o timeout 이 발생하지 않은 이유는 모든 요청이 정상적으로 처리되었기 때문일 것이다.

위에 언급했듯이 `connection-timeout` 은 커넥션이 수락된 이후의 타임아웃 설정이기 때문에 최대 커넥션 개수 설정인 `max-connections` 와는 관련이 없다.

5번의 경우는 i/o timeout 의 원인을 명확하게 특정할 수 없어서 확신할 수 없지만, 너무 많은 요청이 발생했고 연결이 수락되지 않으면서 i/o 이 진행되지 못했던걸까..? 라고 대략적으로 추정만 하고 있다.

##### 10k problem 결론

maxConnections 과 acceptCount 모두 최대 커넥션에 영향을 주므로 둘의 합이 10k 를 넘게 한다면 동시 발생하는 10k 커넥션도 꽤 여유롭게 수락할 수 있다. 적절한 비율은 커넥션 생성 비용을 따져봐야할 것이다.

![](https://i.imgur.com/kqFYz7r.png)

![](https://i.imgur.com/4t3cnnO.png)

_10k 성공_

## 얼마나 처리 가능할까?

결론부터 말하자면, 결론이 나와야할 부분이긴 하지만, 15000 vus 까지는 에러없이 처리할 수 있었다.

![](https://i.imgur.com/EQh4bqh.png)

설정은 아래처럼 사용했다.

```yaml
thread:
  max: 2000
max-connections: 50000
accept-count: 5000
```

다소 과격한(?) connections 과 `accept-count` 값이지만, `max-connections` 값이 크다해서 실제로 그만큼 커넥션을 많이 수락할 수 있다는 의미는 아니다.

또한 커넥션을 많이 수락할 수 있다는 것이 요청을 처리할 수 있다는 의미는 아니다. 커넥션이 수락되어도 처리속도가 충분히 빠르지 않다면 결국 클라이언트는 응답을 60s 안에 받지 못해 request timeout 이 발생할 것이기 때문이다.

> max-connections 는 그릇에 최대로 채울 수 있는 물의 부피이며, 처리 속도(throughput)는 물을 퍼내는 속도이다. 정해진 시간 안에 물을 다 퍼내지 못하면 OS 라는 관리자는 그릇에 남은 물을 다 쏟아버린다.

이번 테스트에 사용한 인스턴스 사양에서는 15k 까지도 CPU 를 거의 사용하지 않고도 처리할 수 있었다. 20k 정도부터는 `cannot assign requested address` 에러가 발생했다. 소켓이나 포트 할당과 관련된 네트워크 문제가 아닐까 싶은데 정확하게 알아내지는 못해서 이 부분은 다음 기회에 네트워크를 추가적으로 학습하면서 확인해봐야할 것 같다.

최근 'Spring MVC 가 동시 접속자를 몇 명이나 처리할 수 있나요?' 라는 질문에 애매모호하게 대답할 수 밖에 없던게 아쉬워서 확인해보게 되었다. 이번 작업을 통해 새로운 의문만 더 늘어난 것 같지만, Spring MVC 와 OS 네트워크 사이를 살짝은 들여다볼 계기가 되었다.

## Summary

- `max-connections`, `accept-count` 는 애플리케이션이 사용하는 커넥션 수에 영향을 준다
- `thread.max` 는 처리량(throughput)에 직접적인 영향을 주는 중요한 속성이다
- `connection-timeout` 은 커넥션을 맺지 못할 때 발생하는 request timeout 과는 관련이 없다
- `max-connections` 이 충분히 큰 값으로 설정되어 있더라도, OS 가 수용할 수 있는 커넥션에는 한계가 있다.
- `accept-count` 는 `max-connections` 을 초과했을 때 OS 가 connection 을 추가적으로 수락하도록 한다. 단순한 작업 큐 이상의 의미를 가진다.

> [!info]
> 글에 사용된 코드는 [GitHub]()에서 확인하실 수 있습니다.

## Nest Step

- allocate memory error 는 서버 측 메모리를 늘리거나, swap 메모리를 설정하는 것이 해결방법이 될 수 있다.
- i/o timeout 의 발생 원인을 알아본다.

## Reference

- https://k6.io/docs/test-types/spike-testing/
- https://shdkej.com/blog/100k_concurrent_server/
- https://www.baeldung.com/spring-boot-configure-tomcat
- https://junuuu.tistory.com/835

[^1]: https://k6.io/docs/using-k6/scenarios/concepts/graceful-stop/
[^2]: https://www.baeldung.com/spring-boot-configure-tomcat#3-server-connections
[^3]: 1의 오차는 여전히 미스터리이다.