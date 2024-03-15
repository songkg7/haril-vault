---
title: "[gum] 세련된 sh 을 작성해보자"
date: 2024-03-14 22:02:00 +0900
aliases: 
tags:
  - cli
  - bash
  - automation
  - s3
categories: 
updated: 2024-03-15 22:53:00 +0900
---

### Situation

- 코드 베이스가 늘어나며 스프링 애플리케이션 실행에 필요한 환경변수가 늘어나고 있음
- 대부분의 상황은 테스트 코드로 검증하지만, 로컬에서 bootRun 으로 테스트해보는 방법도 써야할 때가 있음 = 스모크 테스트

### Complication

- env 들을 분리하여 별도로 관리하고 싶음
- `.env` 파일은 일반적으로 git ignore 대상이므로 버전 추적이 어렵고, 파편화되기 쉬움
    - 여러 머신에서 파일을 동기화할 수 있는 방법이 필요함

### Question

- 개발자들 간에 괴리가 덜하면서도, 편리하게 적용 가능한 방법이 있는가?
    - 가급적이면 익숙한 방법이어야 유지하기도 쉽다
- `.env` 파일의 버전을 관리할 수 있는가?
- 러닝커브가 낮은가?
    - 배보다 배꼽이 커지는 상황은 피하고 싶다
- 운영환경에 바로 적용 가능한가?

### Answer

#### AWS S3

- `.env` 업데이트가 필요한 경우 [[AWS CLI]] 를 사용하면 편리하게 업데이트 가능
- 스냅샷을 통해 `.env` 버전을 관리할 수 있음
- AWS S3 는 대부분의 개발자에게 이미 익숙한 서비스고 러닝커브가 높지 않음
- 서비스 운영 환경인 AWS ECS 는 S3 의 arn 을 사용하여 바로 시스템 변수 적용이 가능함

### 이걸로 끝?

하지만 아직도 몇가지 문제가 있다.

#### 그래서 어느 버킷에 환경변수가 있나

```bash
aws s3 cp s3://something.service.com/prefix/.env .env
```

`.env` 파일이 없는 경우 [[AWS CLI]] 를 사용하여 `.env` 파일을 내려받아야 한다. 미리 버킷 이름을 공유받지 않으면 환경변수 파일을 찾기가 쉽지 않다. 근데 공유하는 과정을 없애려고 한건데, 다시 뭔가를 공유 받아야하는걸까

![](https://i.imgur.com/zoRtk5z.png)
_버킷은 너무 많다_

#### 스프링부트는 시스템 환경변수가 필요하다. `.env` 가 아니라...

스프링부트는 yaml 파일의 placeholder 에 시스템 환경변수를 읽어서 값을 채운다. 그러나 `.env` 파일만으로는 시스템 환경변수 적용이 안된다. 즉, `.env` 를 읽고 적용할 별도의 방법이 필요 (예시 및 사진 첨부)

```yaml
# application.yml
something:
    hello: ${HELLO} # OS 에서 HELLO 라는 환경변수를 찾아서 값을 채운다
```

![](https://i.imgur.com/bVKHxCP.png)
_출력값이 없다면 application.yml 에 설정되지 않는다_

%% 데모 애플리케이션 실행결과 캡쳐 삽입 %%

## 최최종.final

- s3 에서 `.env` 탐색을 도와줄 스크립트를 구현하고 애플리케이션에 포함시킨다.

## Reference

- https://maciejwalkowiak.com/blog/beautiful-bash-scripts-with-gum/
