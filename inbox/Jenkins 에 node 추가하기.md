---
title: "Jenkins 에 node 추가하기"
date: 2022-12-30 11:27:00 +0900
aliases: 
tags: 
categories: 
---

[[Jenkins]] 에 node 를 추가하게 되면 Jenkins 자체의 부하를 줄이고 서버 자원을 효율적으로 활용할 수 있게 된다.

### Error 대처

`No ECDSA host key is known for gitlab.com and you have requested strict checking.` 가 출력될 경우 아래 명령을 통해 해당 repository 를 `known_hosts` 에 등록 후 재실행한다.

```bash
git ls-remote -h git@gitlab.com:seavantage/backend/bespoke/svmp-portinsight-batch-statistic.git HEAD
```

permission denied (publickey) 가 발생할 경우, `.ssh` directory 의 실행권한을 확인해본다.

