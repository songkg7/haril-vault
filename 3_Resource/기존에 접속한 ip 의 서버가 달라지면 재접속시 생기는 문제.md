---
title: 기존에 접속한 ip 의 서버가 달라지면 재접속시 생기는 문제
date: 2023-10-13 10:07:00 +0900
aliases: 
tags:
  - ssh
  - server
  - trouble-shooting
categories: 
updated: 2023-10-13 10:07:30 +0900
---

서버를 밀고 새로 작업하거나, 동일한 아이피로 다른 서버를 세팅하게 되면 아래와 같은 문제가 발생한다.

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is...
이하 생략
```

아래 명령어를 사용하여 접속 정보를 초기화하여 해결할 수 있다.

```bash
ssh-keygen -R {대상 서버 ip}
```
