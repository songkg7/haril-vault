---
title: "Swap memory 설정"
date: 2023-01-20 09:39:00 +0900
aliases: 
tags: [linux, memory, swap]
categories: 
---

[[AWS EC2]] 는 기본적으로 swap memory 가 할당되어 있지 않다. 메모리가 충분할 경우에는 굳이 할당할 필요가 없지만 만약 기본 메모리가 부족하다면, swap memory 를 할당해주면 좀 더 쾌적한 환경을 구성할 수 있다.

1. 현재 사용 중인 메모리 구성 확인

```bash
free -h
```

```
              total        used        free      shared  buff/cache   available
Mem:           3.7G        432M        2.3G        192M        960M        2.8G
Swap:            0B          0B          0B
```

swap memory 는 저장장치의 자원을 빌려와서 RAM 처럼 사용하는 것이므로 순수하게 RAM 만 사용할 때보다는 속도가 느릴 수 있다. 메모리 공간이 넉넉하다면 swap memory 공간을 할당하지 않는 것이 속도나 디스크 수명 측면에서 유리하다.

## Reference

https://shanepark.tistory.com/378
- [EC2 에 swap memory 설정하기](https://aws.amazon.com/ko/premiumsupport/knowledge-center/ec2-memory-swap-file/)