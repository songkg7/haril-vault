---
title: Docker Study Chapter 9
date: 2023-11-01 12:39:00 +0900
aliases: 
tags:
  - docker
  - study
  - grafana
  - prometheus
  - monitoring
  - observability
categories: 
updated: 2023-11-03 11:59:37 +0900
---

# 컨테이너 모니터링으로 투명성 있는 애플리케이션 만들기

---

## 모니터링 기술 스택

- 프로메테우스(Prometheus)
- 그라파나([[Grafana]])

---

## Prometheus

> 로그 수집기

---

```json
{
    "metrics-addr": "0.0.0.0:9323"
}
```

메트릭 정보 수집을 위해 외부로 측정값을 공개해야 한다.

> [!NOTE]
> 이 기능은 더 이상 experimental 기능이 아니므로 boolean 플래그는 필요하지 않다.

---

```bash
docker run -e DOCKER_HOST=$hostIP -d -p 9090:9090 diamol/prometheus:2.13.1
```

컨테이너가 실행되면 http://localhost:9090 을 통해 프로메테우스의 웹 애플리케이션으로 접근할 수 있다.

개발자가 할 일은 컨테이너마다 측정값을 수집할 엔드포인트를 만들고 프로메테우스가 이들 엔드포인트에서 주기적을 정보를 수집하게 하는 것이다.

---

시스템 메트릭 로그들은 프로메테우스만으로도 수집할 수 있지만 비즈니스 정보들은 애플리케이션 레벨에서 명시적으로 코드를 생성하여 로그로 출력해야한다. [[Structured Logging]] 이라는 키워드를 찾아보자.

---

## Grafana

> 시각화 대시보드 오픈소스

---

### 골든 시그널

어떤 측정값들을 모니터링해야할까? 구글의 '사이트 신뢰성 엔지니어링'에서는 4가지 값들을 주요 측정값으로 지목하며 **골든 시그널** 이라고 부른다.

- 지연 시간
- 트래픽
- 오류
- 가용 시스템 자원

---

측정값 중에서 가장 애플리케이션에 중요한 데이터를 모아 하나의 화면으로 구성할 수 있어야 한다. 그래야만 한눈에 이상 상황을 파악하고 사태가 악화되기 전에 과감한 조치를 취할 수 있다.

---

## Fixed

205p 의 실습을 진행하다보면 아래와 같은 로그를 마주하게 된다. 첫줄은 `HOST_IP` 라는 환경 변수가 없다는 것이고, 두 번째 줄은 deprecated 된 문법을 사용해서 출력되는 로그이다.

![[Pasted image 20231103104954.png]]

아래 방법들로 경고 로그를 해결하고 정상적으로 실습을 진행할 수 있다.

```bash
echo "HOST_IP=$(ifconfig en0 | rg 'inet\s' | awk '{print $2}')" > .env
```

```yaml
networks:
  app-net:
    external: true
    name: nat
```

![[Pasted image 20231103110011.png]]

## Reference

https://docs.docker.com/config/daemon/prometheus/
