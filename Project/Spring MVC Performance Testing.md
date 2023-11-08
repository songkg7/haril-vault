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
updated: 2023-11-08 22:32:51 +0900
---

## Goals

> [[Spring MVC]] 웹 애플리케이션은 동시 사용자를 몇 명까지 처리할 수 있을까? 🤔

- $ Spring MVC 의 최대 트래픽 처리량 확인
- AWS EC2 에 IAM 을 사용한 로그인 방법 학습
- AWS ECR 을 활용한 애플리케이션 배포의 기본적인 워크플로우 학습

이상의 3가지 기본 사용법을 학습하여 이후 환경이 어떻게 변하더라도 대응할 수 있도록 하는 것을 목표로 한다.

## Enviroment

- SpringBoot 3.x, Spring MVC
- AWS EC2(Amazon Linux 64bit ARM) 1대
- [[AWS ECR]]
- [[K6]]

## Test Scenario

- 동시에 200명 이상의 사용자가 API 를 요청하는 상황을 가정
- 해당 API 가 너무 빨리 응답하는 것을 방지하고, 어느 정도의 지연을 모의하기 위해 5초의 대기시간을 갖도록 구현
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

이대로라면 이미지의 identify 가 지정되지 않아 image 를 push 할 수 없다. 이후에는 편리한 이미지 배포를 위해 [[Java Image Builder|JIB]] 를 사용할 것이지만, 우선은 ECR 을 사용하기 위해 [[IAM]] role 을 생성하여 [[AWS CLI]] 에 로그인할 수 있도록 설정해보자.

> [!NOTE]
> AWS CLI 를 사용하려면 IAM User 의 access key 와 secret key 가 필요하니 이것은 미리 생성해서 `aws configure` 를 통해 인증해두자.

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

%% ### VPC 생성 %%

### EC2 인스턴스 생성

#### Docker 설치

```bash
sudo yum update -y
sudo yum install docker -y
```

```bash
 sudo systemctl start docker # 도커 데몬 실행
sudo systemctl enable docker
```

![[Pasted image 20231107145058.png]]

도커는 항상 root 로 실행되기 때문에 편의를 위해 일반 사용자에게도 도커 실행 권한을 부여해주려 한다. ec2-user 를 docker 그룹에 추가함으로써 sudo 명령어를 사용하지 않고도 도커를 사용할 수 있게 해보자.

```bash
sudo usermod -aG docker [username]
sudo systemctl restart docker
```

이후 ec2-user 를 로그아웃했다가 다시 접근해보면 `docker ps` 명령을 실행할 수 있는 것을 확인할 수 있다.

![[Pasted image 20231107145019.png]]

우선은 여기까지만 진행해두자.

### ECR registry 생성

ECR registry 생성은 클릭 몇 번

private registry 를 생성하고 리포지토리를 생성해준다. 이 때 리포지토리의 이름은 도커 이미지 이름으로 해야 하며, 이 리포지토리에 같은 이름의 이미지들이 버전 별로 저장되게 된다. sample-server 라는 ECR Repository 를 하나 생성했다.

![[Pasted image 20231107142000.png]]

check box 에 체크 표시를 하면 푸시 명령 보기 탭이 활성화 되는데 이 탭에서 ecr 에 로그인하는 과정 및 이미지를 푸시하는 과정이 자세히 설명되어 있으니 따라서 진행한다.

![[Pasted image 20231107142116.png]]

_이미지 푸시 완료_

### EC2 인스턴스에 이미지 배포하기

우리가 선택한 AWS Linux 2 에는 [[AWS CLI]]가 기본적으로 설치되어 있다.

```bash
aws --version
```

aws cli 는 EC2 인스턴스의 경우 EC2InstanceMetadata 를 사용하여 인증 정보를 해결할 수 있기 때문에, 인스턴스에 적절한 role 만 설정되어 있다면 별도의 토큰 없이도 cli 를 호출할 수 있다.

```bash
aws sts get-caller-identity
```

로그인을 진행해보자. 명령어는 ECR 에 이미지를 푸시했을 때 사용했던 명령어와 비슷하다.

![[Pasted image 20231107143718.png]]

_별도의 인증 없이도 로그인이 성공한다_

> [!NOTE] AccessDeniedException 이 발생하는 경우
> `ecr:GetAuthorizationToken` 권한을 EC2 인스턴스가 보유하고 있어야 한다. 웹 콘솔에서 인스턴스가 보유한 권한을 확인해보고, 없다면 권한을 추가해주면 된다. 필자는 `EC2InstanceProfileForImageBuilderECRContainerBuilds` role 을 default-ec2-ssm-role 에 추가해뒀다.

![[Pasted image 20231107144228.png]]

이후는 간단하다. ECR registry 에 있는 이미지를 run 명령을 통해 실행시키면 된다.

```bash
docker run -p 8080:8080 --name sample-server -d 056876186590.dkr.ecr.ap-northeast-2.amazonaws.com/sample-server:latest
```

![[Pasted image 20231107145644.png]]

_배포 완료!_

이제 테스트를 위한 서버 준비는 끝났다. 다음은 API 서버를 로컬에서 호출할 수 있도록 외부의 접근을 허용하는 과정을 진행해본다.

### EC2 인스턴스 외부에 공개하기

기본적으로 EC2 인스턴스에 설정하는 보안 그룹은 아웃바운드는 모두 허용하지만 인바운드는 제한한다. public IP 를 사용하는 EC2 인스턴스라면 보안 그룹의 인바운드 설정을 수정하여 외부 접근을 허용할 수 있다.

- 모든 트래픽, 본인의 IP 만

![](https://i.imgur.com/cBePThO.png)

이렇게 설정하면 외부 트래픽이 EC2 로 접근할 수 있게 된다.

실제 운영 환경이라면 [[VPC]] 설정을 통해 private network 로 설정하고 사용해야하겠지만, 해당 내용은 다른 글에서 다뤄보겠다.

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
> Grafana 의 초기 계정정보는 아이디와 비밀번호 모두 admin 을 입력하면 된다. 비밀번호를 변경하라고 나오겠지만, 이번 그라파나 설정 목표는 운영이 아니라 테스트이므로 skip 해도 무방할 것이다.

### Script 작성

- ! 스크립트 수정할 것
- 사실 스파이크 테스트라고 하긴 좀 애매

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

K6 에서는 일정 시간 이상 실행되는 테스트를 중지하는 `gracefulStop`[^1] 기능이 존재한다. 이 기능은 30s 가 기본값으로 설정되어 있어서 **request timeout 을 보기 전에 테스트를 중단**시키므로, 스크립트를 좀 수정해서 더 오랜 기간 테스트가 수행되도록 해야 한다.

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

예상했던 고비가 온다.

![](https://i.imgur.com/rM78o5F.png)

이번에는 요청이 1분이상 대기하게 되면서 request timeout 이 발생한다.

- [?] request timeout 이 1m 이라는 설정은 어디에 있을까?

200 스레드로 3000 개의 요청을 처리하므로, 5초의 대기시간까지 고려해보면 운이 없는 유저의 요청은 $3000 / 200 * 5 = 75(s)$ 를 대기해야 한다. 따라서 타임아웃 회피를 위해서는 15초 이상 시간의 단축이 필요하며, 기본설정으로는 request timeout 을 피하기 어려워보인다.

1. thread pool 의 사이즈를 200 에서 500 정도로 늘리면 동시 처리량이 늘어나면서 해결될 것이다.
2. ??

이전에 `application.yml` 에 미리 정의해둔 속성을 활용해보자.

```bash
docker run -d -p "80:8080" -e TOMCAT_MAX_THREADS=500 --name sample-server --restart always 123456789012.dkr.ecr.ap-northeast-2.amazonaws.com/sample-server:v1
```

`-e TOMCAT_MAX_THREADS=500` 옵션을 통해서 컨테이너 내부에 환경변수를 넣어줬다. 이 환경변수는 `application.yml` 의 자리로 찾아가서 스레드풀 설정을 변화시킨다.

[[Spring Actuator|Spring Actuator]] 를 사용하면 `/actuator/configprops` 를 통해서 적용된 설정을 확인할 수 있다.

![](https://i.imgur.com/oapPtMS.png)

이후 다시 한 번 테스트를 해보면...

![](https://i.imgur.com/IaRf7y3.png)

![](https://i.imgur.com/xLVxU9w.png)

이번에는 타임아웃 없이 처리되는 것을 확인할 수 있다.

서버의 리소스를 이전보다는 쓰게 되겠지만, 처리속도가 월등히 빨라져서 75s 에서 30s 로 줄어들게 되었다.

$3000 / 500 * 5 = 30(s)$

#### 6000 requests

- [?] dial tcp $(IP): connect: cannot allocate memory"

![](https://i.imgur.com/3dorRSj.png)

스레드 풀을 500 으로 늘렸지만, 6000 requests 부터는 다시 request timeout 에 걸린다. 더 동시처리량을 늘려야할 필요가 있다. 스레드가 너무 많으면 리소스 경합이 발생하므로 그다지 바람직하지 못하지만, 우선 가능할 때까지 스레드를 늘리는 방향으로 생각해보자. 이전과 같은 방식을 사용하여 1000 개로 늘려줬다.

- [?] 스레드는 몇개까지 늘리는게 가능할까?

![](https://i.imgur.com/l7uzhej.png)

_thread pool 1000 에서 다시 성공_

#### 10k requests

![](https://i.imgur.com/IFYLBPd.png)

- [!] i/o timeout
- [!] request timeout
- [!] cannot allocate memory"
- [!] connection reset by peer

10k 에서 i/o timeout 이 처음으로 발생했다.

테스트 실행 후 20s 에서 request timeout 이 발생했다. 20s 는 connection-timeout 과 일치한다.

우선 테스트 실행 시점에서 TCP 개 몇개나 열리는지 모니터링해봤다.

```bash
# 열려있는 TCP 수 모니터링
watch ss -s
```

![](https://i.imgur.com/LCIm2BW.png)

10k 의 TCP 커넥션을 맺을 수 없는 것을 확인했다.  지금까지는 유저의 수대로 정확하게 TCP 커넥션이 증가하는 것을 확인했는데 처음으로 커넥션 개수가 모자라기 시작했다.

allocate memory 는 API 서버에 메모리를 늘리거나, swap 을 통해서 해결할 수 있을지 살펴본다.

## Nest Step

- [[IAM Identity Center 를 활용한 SSO 인증 활성화|IAM Identity Center 를 활용한 SSO 인증 활성화]] 를 살펴보면 access key 를 로컬에서 관리할 필요가 없어진다.
- SSM 접근은 public IP 를 사용할 필요가 없다. VPC 를 설정하여 서버를 외부로부터 격리할 수 있다.

---

## Private IP 로 사용하는 경우

private 환경을 위해서 [[VPC]] 를 새로 만들어 준다.

### VPC 엔드포인트 생성

- ssm
- ssmmessages
- ec2messages

---

## Reference

- https://k6.io/docs/test-types/spike-testing/
- https://shdkej.com/blog/100k_concurrent_server/

---

- EC2InstanceMetadata: AWS EC2 안에서 [[AWS CLI]] 를 사용하는 경우, 보안 자격 증명을 보다 쉽게 해결해준다

[^1]: https://k6.io/docs/using-k6/scenarios/concepts/graceful-stop/
