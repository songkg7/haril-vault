---
title: Docker Log
date: 2023-06-13T12:02:00
aliases: 
tags:
  - log
  - docker
categories: 
updated: 2025-01-07T00:35
---

### Log 관리

```bash
# 한 로그 파일 당 최대 크기를 3Mb로 제한하고, 최대 로그파일 3개로 로테이팅  
docker run \\  
-d \\  
--log-driver=json-file \\  
--log-opt max-size=3m \\  
--log-opt max-file=5 \\  
nginix
```

## Links

- [[How to logging|Log 를 잘 남기는 법]]

## Reference

- [애플리케이션 로그에 장애 흔적이 없다면](https://medium.com/@arneg0shua/%EC%95%A0%ED%94%8C%EB%A6%AC%EC%BC%80%EC%9D%B4%EC%85%98-%EB%A1%9C%EA%B7%B8%EC%97%90-%EC%9E%A5%EC%95%A0-%ED%9D%94%EC%A0%81%EC%9D%B4-%EC%97%86%EB%8B%A4%EB%A9%B4-vi-%ED%99%9C%EC%9A%A9%ED%8E%B8-d4e82c171e6f)
