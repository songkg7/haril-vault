---
title: Semantic release
date: 2022-11-03 14:14:00 +0900
aliases: 
tags:
  - release
  - automation
  - semantic-version
categories: 
updated: 2023-10-21 14:50:35 +0900
---

## Overview

`CHANGELOG.md` 등 release 정보에 대한 기록은 사용자뿐만 아니라 개발자를 위한 것이기도 하다. 언제 어떤 기능을 배포하고 수정하였는지 파악하는 것에 큰 도움이 되기 때문이다.

## Content

다음 명령어로 사용 가능, 필요한 플러그인은 별도로 설치해줘야 한다. `package.json` 설정에 동작이 영향을 받으니 주의한다.

```bash
npx semantic-release
```

```bash
# dry-run, 실제로 publish 되지는 않는다.
npx semantic-release -d
```

```bash 
# local 실행 옵션
npx semantic-release --no-ci
```

설정파일은 `.releaserc.json` 이라는 파일로 할 수 있다. json 뿐만 아니라 여러 가지 파일 형식을 지원하니 공식 문서를 참고하면 되겠다.

```json
{
  "branches": ["main", {
    "name": "develop",
    "prerelease": "beta"
  }],
  "prepare": [
    "@semantic-release/changelog",
    {
      "path": "@semantic-release/git",
      "assets": [
        "CHANGELOG.md"
      ],
      "message": "chore(release): ${nextRelease.version}"
    }
  ],
  "tagFormat": "${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    [
      "@semantic-release/gitlab",
      {
        "gitlabUrl": "https://gitlab.com",
        "gitlabApiPathPrefix": "/api/v4"
      }
    ]
  ]
} 
```

**branches**:

remote 에 해당 브랜치가 존재하지 않으면 동작하지 않는다.

name, channel, prerelease, range 옵션이 존재

channel 의 경우 특정 브랜치마다 버전 전략을 다르게 가져가고 싶을 때 사용할 수 있는 일종의 그룹같은 것이라고 이해하고 있다.

prerelease 옵션을 true 로 할 경우 name 을 suffix 로 사용하여 x.x.x.name-x 같은 형식으로 나온다. true 가 아닌 string value 를 지정해주면, x.x.x.custom-x 같은 형식으로도 만들 수 있다.

## Exception case

[tag 관련](https://stackoverflow.com/questions/58031165/how-to-get-rid-of-would-clobber-existing-tag)

## Reference

- [semantic release](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/configuration.md#branches)
- https://semver.org/
