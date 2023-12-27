---
title: "Docker container restart policy"
date: 2022-09-13 11:58:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-13
aliases: 
tags: [docker, restart]
categories: 
updated: 2023-05-09 12:20:19 +0900
---

[[Docker|Docker]] container 기반으로 서비스를 운영하다보면 컨테이너가 중지될때가 있을 수 있다. 이럴 때 컨테이너를 수동으로 재시작하지 않아도 스스로 시작된다면 관리부담이 줄어들지 않을까? 이런 고민에서 등장한 것이 restart policy 이다.

쿠버네티스나, 테라폼 같은 서비스를 사용한다면 해당 서비스가 알아서 재시작을 시켜주겠지만 적은 컨테이너만 운영할 경우 관련 서비스를 사용하는 것은 과한 부담이 될 수 있기 때문에 간단하게 적용할 수 있는 이러한 옵션이 유용하게 사용될 수 있다.

```bash
docker run --restart always
```

```bash
docker update --restart=always TestContainer
```

```bash
docker update --restart unless-stopped redis
```

사용할 수 있는 옵션의 종류는 다음과 같다.

- no
- on-failure[:max-retries]
- always
- unless-stopped: always 와 비슷하지만 수동으로 중지시킨 경우, daemon 이 재시작되도 다시 실행되지 않는다.

## Reference

- [docker docs](https://docs.docker.com/config/containers/start-containers-automatically/)
