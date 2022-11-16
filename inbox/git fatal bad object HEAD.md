---
title: "git fatal bad object HEAD"
date: 2022-11-10 21:03:00 +0900
aliases: 
tags: [git, error, solution]
categories: 
---

icloud 에 repository 를 백업한 상태로 사용하다보면 가끔 원인불명의 오류로 `fatal: bad object HEAD` 라는 에러가 출력될 때가 있다. 이럴 땐 대부분의 git command 가 말을 듣지 않는데 해결 방법을 적어본다.

가장 마지막 커밋 하나를 돌린다.

```bash
git reset HEAD@{1}
```

이러면 커밋됐었던 파일들이 unstage 상태로 돌아오고 다시 git command 를 제대로 사용할 수 있다. 이후에 다시 repository 에 push 해주면 되겠다.

### 2. fetch

```bash
git fetch
```

원격 저장소와 비교하며 잘못된 부분을 받는다.

## Links

[[Git]]