---
title: Docker Study Chapter 7
date: 2023-10-23 17:56:00 +0900
updated: 2023-10-28 19:28:08 +0900
aliases: 
tags:
  - docker
  - study
categories: 
related: "[[Docker|Docker]]"
---

---

## Docker Compose

---

### 들어가기 전에

- [[Docker Compose]] 가 V2 로 업데이트됨[^1]에 따라서 deprecated 된 `docker-compose` 명령은 `docker compose` 로 대체하여 설명합니다.

---

### Docker Compose?

- 여러 컨테이너를 묶어 하나로 관리하기 용이하게 하는 방법
- 모든 컴포넌트가 어떤 '상태'로 동작해야 하는지를 설명해주는 파일
- 필요한 모든 도커 객체를 한 번에 생성할 수 있다
- 컨테이너 간 통신이 용이하다

---

### Docker Compose 의 관리

- 도커 컴포즈는 컨테이너를 관리하는 별도의 명령이지만 내부적으로는 도커 API 를 사용
- 컴포즈가 실행된 이후, `docker-compose.yml` 파일을 수정하더라도 컴포즈는 이를 인지하지 못함
- 컴포즈는 yaml 파일에 강하게 의존하는 클라이언트 측 도구로, 컨테이너 리소스는 컴포즈 파일을 통해 관리해야 한다

---

### 컨테이너 간의 통신

- 기본적으로 컨테이너는 생성시에 부여되는 가상 IP 로 통신할 수 있다.
- 하지만 IP 주소는 컨테이너의 라이프사이클에 따라 계속 변화하기 때문에 활용이 어렵다.
- 도커는 같은 네트워크에 포함되어 있다면 DNS 를 사용할 수 있다
- 도커는 DNS 조회 순서를 변화시키는 방법으로 로드밸런싱을 구현한다

---

#### 실습

 ```bash
docker compose up -d --scale iotd=3
```

![[Pasted image 20231026162715.png]]

```bash
$ docker exec -it image-of-the-day-image-gallery-1 sh
/web # nslookup accesslog
nslookup: can't resolve '(null)': Name does not resolve

Name:      accesslog
Address 1: 192.168.228.2 image-of-the-day-accesslog-1.nat
```

컨테이너 이름으로 `nslookup` 기능이 동작하는 것을 볼 수 있다. 

> [!warning] DNS 가 항상 가능한 것은 아니다
> 컴포즈로 인하여 이미 같은 도커 네트워크(nat)에 존재하기 때문에 이 기능이 동작하는 것이고, 만약 도커 네트워크를 사용하지 않는다면 DNS 는 동작하지 않는다.

---

#### 로드밸런싱

하나의 도메인에 대해 DNS 결과에 여러 개의 IP 주소가 나올 수 있다. 도커의 DNS 시스템은 조회 결과의 순서를 매번 변화시키는 방식으로 트래픽을 분산시킨다.

```bash
$ docker exec -it image-of-the-day-image-gallery-1 sh
/web # nslookup iotd
nslookup: can't resolve '(null)': Name does not resolve

Name:      iotd
Address 1: 192.168.228.4 image-of-the-day-iotd-1.nat
Address 2: 192.168.228.5 image-of-the-day-iotd-2.nat
Address 3: 192.168.228.3 image-of-the-day-iotd-3.nat

/web # nslookup iotd
nslookup: can't resolve '(null)': Name does not resolve

Name:      iotd
Address 1: 192.168.228.5 image-of-the-day-iotd-2.nat
Address 2: 192.168.228.3 image-of-the-day-iotd-3.nat
Address 3: 192.168.228.4 image-of-the-day-iotd-1.nat
```

---

### 도커 컴포즈로 설정값 지정하기

- `environment` : 컨테이너 안에서 사용될 환경 변수 값 정의
- `secrets`: 컨테이너 내부의 파일에 기록될 비밀값 정의

개발 환경과 운영 환경의 컴포즈 파일을 다르게 정의하는 식으로 애플리케이션의 기능을 선택적으로 활성화 할 수 있다.

이 외에도 다양한 설정값이 존재하니 필요할 때 찾아보면 되겠다.

---

### 도커 컴포즈도 만능은 아니다

컴포즈는 정의된대로 실행만 해줄 수 있다. 상태 관리나 내결함성을 유지하는 부분까지는 해줄 수 없다. 서로 다른 서버를 관리하는 환경에서도 사용하기 어렵다. 로컬 머신에서만 리소스를 관리할 수 있기 때문이다.

---

### 자주 사용되는 명령어 정리

```bash
docker compose up -d
docker compose stop
docker compose start
docker compose down
docker compose -p {project_name} up
docker compose -p {project_name} down
docker compose -f {compose_file_path} up
docker compose -f {compose_file_path} down
docker compose ls
docker compose logs
```

[^1]: https://docs.docker.com/compose/migrate/
