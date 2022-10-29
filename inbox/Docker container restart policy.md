---
title: "Docker container restart policy"
date: 2022-09-13 11:58:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-13
aliases: 
tags: [docker, restart]
categories: 
---

[[published/Docker]] container 기반으로 서비스를 운영하다보면 컨테이너를 중지시키고 재시작해줘야 하는 경우가 있다. 이럴 때 사용할 수 있는 옵션이 restart 이다.

쿠버네티스나, 테라폼 같은 서비스를 사용한다면 해당 서비스가 알아서 재시작을 시켜주겠지만 적은 컨테이너만 운영할 경우 관련 서비스를 사용하는 것은 과한 부담이 될 수 있기 때문에 간단하게 적용할 수 있는 이러한 옵션이 유용하게 사용될 수 있다.

```bash
docker run --restart always
```

사용할 수 있는 옵션의 종류는 다음과 같다.

- no
- on-failure[:max-retries]
- always
- unless-stopped

## Reference

- [docker docs](https://docs.docker.com/config/containers/start-containers-automatically/)
