---
title: Docker
date: 2022-08-13T22:52:00
tags:
  - docker
  - devops
  - container
categories:
  - DevOps
fc-calendar: Gregorian Calendar
fc-date: 2022-08-13
updated: 2025-01-07T00:36
---

- [[Docker Volume]]
- [[Docker Network]]

# What is Docker?

> _도커는(Docker)는 리눅스의 응용 프로그램들을 프로세스 격리 기술들을 사용해 컨테이너로 실행하고 관리하는 오픈 소스 프로젝트이다. - wikipedia_

> _도커 컨테이너는 일종의 소프트웨어를 소프트웨어의 실행에 필요한 모든 것을 포함하는 완전한 파일 시스템 안에 감싼다. 여기에는 코드, 런타임, 시스템 도구, 시스템 라이브러리 등 서버에 설치되는 무엇이든 아우른다. 이는 실행 중인 환경에 관계 없이 언제나 동일하게 실행될 것을 보증한다. - Docker webpage_

> Linux 컨테이너를 만들고 사용할 수 있도록하는 컨테이너화 기술, 그리고 그 기술을 지원하는 가장 큰 회사의 이름이자 오픈소스 프로젝트의 이름

![[infra 환경의 변화.png]]

2013년에 등장한 도커는 인프라 세계를 컨테이너 세상으로 바꿔버렸다. 수많은 애플리케이션이 컨테이너로 배포되고 도커파일을 만들어 이미지를 빌드하고 컨테이너를 배포하는게 흔한 개발 프로세스가 되었다. 2019년 DockerCon 발표에선 무려 1052억번의 컨테이너 image pull 이 발생했다고 한다.

Docker 를 사용하면 컨테이너를 매우 가벼운 모듈식 가상머신처럼 다룰 수 있다. 또한 컨테이너를 구축, 배포, 복사하고 한 환경에서 다른 환경으로 이동하는 등 유연하게 사용할 수 있어, 애플리케이션을 클라우드에 최적화하도록 지원한다.

# 도커 컨테이너의 이점

## 모듈성

Docker 의 컨테이너화 접근 방식은 전체 애플리케이션을 분해할 필요없이 애플리케이션의 일부를 분해하고, 업데이트 또는 복구하는 능력에 집중되어 있다. 사용자는 이 마이크로서비스 기반 접근 방식 외에도 SOA(service-oriented architecture)의 작동 방식과 동일하게 멀티플 애플리케이션 사이에 프로세스를 공유할 수 있다.

## 계층 및 이미지 버전 제어

각 Docker 이미지 파일은 일련의 계층으로 이루어져있으며 이 계층들은 단일 이미지로 결합된다.

Docker 는 새로운 컨테이너를 구축(Build)할 때 이러한 계층을 재사용하므로 Build 가 훨씬 빨라진다. 중간 변경사항이 이미지 사이에서 공유되므로 속도, 규모, 효율성이 더 개선된다.

## 신속한 배포

Docker 기반 컨테이너는 배포 시간을 몇 초로 단축할 수 있다. 또한 컨테이너를 추가하거나 이동하기 위해 OS 를 부팅할 필요가 없으므로 배포 시간이 크게 단축된다. 이 뿐만 아니라 배포 속도가 빨라 컨테이너에서 생성된 데이터를 비용효율적으로 쉽게 생성하고 삭제할 수 있고 사용자는 제대로 생성 혹은 삭제되었는지 우려할 필요가 없다.

즉, Docker 기술은 효율성을 중시하며 더 세분화되고 제어 가능한 마이크로서비스 기반 접근 방식이다.

## 롤백

도커로 배포할 경우 사용하는 이미지는 tag 를 사용한다. 예를 들어 1.2 버전의 이미지를 사용하여 배포하였을 때, 1.1 버전의 이미지가 저장소에 있으므로 사용자는 jar 파일을 다시 준비할 필요없이 run 명령만 실행하면 된다.

```bash
docker run --name app image:1.2
docker stop app

## 1.1 로 롤백
docker run --name app image:1.1
```

# 도커 사용의 장단점

도커 컨테이너를 사용하면 기존 배포방식에 비하여 훨씬 빠르고 유연한 배포가 가능해진다.

### 도커 컨테이너를 사용하지 않는 배포

1. 로컬 머신에서 배포할 `jar` 파일을 패키징하여 준비한다.
2. `scp` 등 파일 전송 프로토콜을 사용하여 운영 서버로 `jar` 파일을 전송한다.
3. status 관리를 위해 `systemctl` 등을 사용하여 service 파일을 작성한다.
4. `systemctl start app` 으로 application 을 실행한다.

만약 하나의 서버에서 여러개의 앱을 실행 중일 경우는 중지된 앱을 찾는 과정 등 복잡성이 매우 크게 증가한다. 여러 서버에서 여러 앱을 실행 중일 경우에도 별반 다르지 않으며 서버를 이동하며 명령어를 쳐야해서 더욱 피곤한 과정을 거쳐야 한다.

### 도커 컨테이너를 사용한 배포

1. `Dockerfile` 을 사용하여 application 을 이미지화한다. → Build ⚒️
2. Dockerhub, gitlab registry 등 저장소에 image를 `push` 한다. → Shipping🚢
3. 운영 서버에서 `docker run imageName` 을 실행하여 application 을 실행한다.

복잡한 경로 설정 및 파일 전송과정에서 시간을 낭비할 필요가 없으며, 도커는 환경을 가리지 않으므로 어디서나 실행이 보장되어 자원을 효율적으로 사용하게 된다.

Docker 는 단일 컨테이너 관리에 적합하도록 만들어져 있다. 수백 개로 세분화된 컨테이너와 컨테이너화된 앱을 점점 더 많이 사용하기 시작하면 관리와 오케스트레이션이 매우 어려워질 수 있다. 결국 모든 컨테이너 전체에서 네트워킹, 보안, 텔레메트리와 같은 서비스를 제공하기 위해서는 한 걸음 물러나서 컨테이너를 그룹화해야한다. 바로 여기에 쿠버네티스가 사용된다.

<aside> 💡 **배포 방식의 변화 및 성장 과정**

전통적인 jar 파일을 통한 배포

→ 서비스가 많아질수록 모니터링 툴 설치 및 장애 대응 관리가 힘들어짐

→ 모든 서비스를 컨테이너화

→ 장애가 발생하면 restart 하면 간단하게 해결되지만, 여전히 모니터링툴 등 확장에 제한적

→ 컨테이너가 점점 늘어남으로 인해 장애가 생기는 컨테이너도 함께 증가하게 되고, 장애가 발생한 컨테이너를 찾아내서 restart 해줘야하는 등 jar 파일일 때와 비슷한 상황을 마주하게 됨

→ 오케스트레이션 툴의 필요성 대두

→ 쿠버네티스를 도입하여 중지된 컨테이너를 자동으로 재시작하게 됨으로써 단순한 문제에서는 개발자가 신경쓸 필요가 없게 됨. 쿠버네티스를 만들고 오픈한 구글은 일주일에 수십억개의 컨테이너를 자동으로 생성하는 중

</aside>

# 도커가 유용한 경우들

분야를 가리지 않고 개발자라면 거의 모든 상황에서 도커를 매우 유용하게 사용할 수 있다. 사실 개발 및 배포, 운영을 포함한 모든 프로세스에서 일반적인 방법보다 도커가 더 우월한 경우가 많으므로 도커 컨테이너는 항상 1순위로 고려되야 한다고 생각한다.

1. 개발용 PostgreSQL 가 필요한 경우
2. 새로운 기술을 테스트해보거나 간단하게 도입해보고 싶은 경우
3. 설치나 삭제 과정이 까다로운 소프트웨어 등 로컬 머신에 직접 설치하기 부담스러운 경우 (ex. Java는 윈도우에서 재설치하기가 아주 끔찍하다)
4. frontend 등 다른 팀의 최신 배포 버전을 로컬에서 실행시켜보고 싶은 경우
5. 운영 서버를 NCP 에서 AWS 로 바꿔야하는 경우, 도커 컨테이너로 되어 있다면? 혹은 jar 로 배포했다면?

# Example

AIS decoder

```bash
docker run --name ais-decoder registry.gitlab.com/seavantage/tools/ais-decode-by-point
```

svmp web 실행

```bash
docker run --name web -p 8081:8081 registry.gitlab.com/seavantage/frontend/bespoke
```

현재 개발서버의 API 는 테스트 커버리지가 낮기 때문에 개발서버에 우선 배포한 뒤 화면을 직접 클릭해보는 방식으로 테스트를 진행하고 있다. 개발서버에 배포하지 않고 로컬에서 먼저 테스트할 수는 없을까?

1. 프론트엔드의 프로젝트를 clone 한 뒤 IDE 혹은 editor 에서 직접 실행
2. 프론트엔드의 프로젝트에 docker build 과정을 추가한 뒤 shipping

프론트엔드의 code 를 clone 해서 실행시키는건 `npm install` 등 굉장히 번거로운 과정을 거쳐야한다. 하지만 도커 컨테이너로 준비되어 있다면, 별도의 과정없이 명령어 한줄로 실행할 수 있다.

간단한 API server

```bash
docker run --name rest-server -p 80:8080 songkg7/rest-server
```

```bash
# curl 사용시
curl <http://localhost/ping>

# httpie 사용시
http localhost/ping
```

80 port 를 container 의 8080 port 와 매핑했기 때문에 컨테이너와 잘 통신되는 것을 볼 수 있다.

## CLI options

`--name`: Assign a name to the container

`-p`: publish a container's port(s) to the host

`--rm`: Automatically remove the container when it exits

`-i`: interactive, Keep STDIN open even if not attached 입출력 기능을 허용

`-t`: tty, Allocate a pseudo-TTY, 터미널과 비슷한 환경을 생성

`-v`: Bind mount a volume

# Conclusion

현재 회사의 프로젝트 중 상당 수가 이미지화되어 있지않고 전통적 jar 배포 방식에 의존하고 있다. 도커 컨테이너를 사용하면 전통적인 방식에서 발생하는 문제를 해결하면서 편리한 운영을 가능하게 한다. 다음은 `Dockerfile` 을 통해 이미지화에 대해 알아본다.

## Reference

- https://gngsn.tistory.com/128
- https://blog.cloudacode.com/%EB%8F%84%EC%BB%A4%EB%8A%94-%EB%AC%B4%EC%97%87%EC%9C%BC%EB%A1%9C-%EC%96%B4%EB%96%BB%EA%B2%8C-%EA%B5%AC%EC%84%B1%EB%90%98%EC%96%B4-%EC%9E%88%EC%9D%84%EA%B9%8C-1b2a52ca8d1c