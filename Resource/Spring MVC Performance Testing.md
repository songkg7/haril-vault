---
title: Spring MVC Performance Testing
date: 2023-11-06 10:33:00 +0900
aliases: 
tags:
  - test
  - k6
  - aws
  - stress-test
categories: 
updated: 2023-11-06 17:37:02 +0900
---

## Goals

> [[Spring MVC]] 웹 애플리케이션은 동시 사용자를 몇 명까지 처리할 수 있을까? 🤔

- $ Spring MVC 의 최대 트래픽 처리량 확인
- AWS EC2 에 IAM 을 사용한 로그인 방법 학습
- AWS ECR 을 활용한 도커 이미지 배포의 기본적인 워크플로우 학습

이상의 3가지 기본 사용법을 학습하여 이후 환경이 어떻게 변하더라도 대응할 수 있도록 하는 것을 목표로 한다.

## Enviroment

- AWS EC2(Amazon Linux 64bit ARM) 1대
- [[AWS ECR]]
- [[K6]]

## Test Scenario

- 동시에 200명 이상의 사용자가 API 를 요청하는 상황을 가정
- 해당 API 가 너무 빨리 응답하는 것을 방지하고, 어느 정도의 지연을 모의하기 위해 1초의 대기시간을 갖도록 구현
- Spring MVC 의 쓰레드풀 설정을 조절해가면서 트래픽 처리량을 검증
- API 는 EC2 에 배포해놓은 상태에서, 로컬에서 EC2 로 부하를 발생

## Action

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
        TimeUnit.SECONDS.sleep(1); // 처리 시간을 시뮬레이션
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
  port: 8080                  # 서버를 띄울 포트번호
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
  port: ${TOMCAT_PORT:8080}
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

이대로라면 이미지의 identify 가 지정되지 않아 image 를 push 할 수 없다. 이후에는 편리한 이미지 배포를 위해 [[Java Image Builder|JIB]] 를 사용할 것이지만, 우선은 ECR 을 사용하기 위해 [[IAM]] role 을 생성하여 [[AWS CLI]] 에 로그인할 수 있도록 설정해보자.

### IAM role 생성

![[Pasted image 20231106123949.png]]

![[Pasted image 20231106124020.png]]

생성을 클릭하면 IAM role 이 하나 생성된다.

접속해보면 다음과 같은 문제가 발생할 것이다.

```bash
aws ssm start-session --target {instance_id}

SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-manager-plugin-not-found
```

### aws session manager plugin 설치

```bash
brew tap dkanejs/aws-session-manager-plugin
brew install aws-session-manager-plugin
```

### EC2 인스턴스 생성

## Private 로 사용하는 경우

default VPC 로는 private 환경이 안되었기 때문에 private 환경을 위해서 [[VPC]] 를 새로 만들어줘야 했다.

### VPC 엔드포인트 생성

- ssm
- ssmmessages
- ec2messages

---

- EC2InstanceMetadata: AWS EC2 안에서 [[AWS CLI]] 를 사용하는 경우, 보안 자격 증명을 보다 쉽게 해결해준다
