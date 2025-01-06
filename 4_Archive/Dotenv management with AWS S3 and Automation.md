---
title: AWS S3 를 사용한 env 관리 방법 및 자동화
date: 2024-03-14T22:02:00
aliases: 
tags:
  - cli
  - bash
  - automation
  - s3
categories: 
updated: 2025-01-07T00:36
---

## Situation

- 코드 베이스가 늘어나며 스프링 애플리케이션 실행에 필요한 설정값이 늘어나고 있음
- 대부분의 상황은 테스트 코드로 검증하지만, 로컬에서 bootRun 으로 테스트해보는 방법도 써야할 때가 있음

## Complication

- 설정값들을 env 로 분리하여 별도로 관리하고 싶음
- `.env` 파일은 일반적으로 git ignore 대상이므로 버전 추적이 어렵고, 파편화되기 쉬움
    - 여러 머신에서 파일을 동기화할 수 있는 방법이 필요함

## Question

- 개발자들 간에 괴리가 덜하면서도, 편리하게 적용 가능한 방법이 있는가?
    - 가급적이면 익숙한 방법이어야 유지하기도 쉽다
- `.env` 파일의 버전을 관리할 수 있는가?
- 러닝커브가 낮은가?
    - 배보다 배꼽이 커지는 상황은 피하고 싶다
- 운영환경에 바로 적용 가능한가?

## Answer

### AWS S3

- `.env` 업데이트가 필요한 경우 [[AWS CLI]] 를 사용하면 편리하게 업데이트 가능
- 스냅샷을 통해 `.env` 버전을 관리할 수 있음
- AWS S3 는 대부분의 개발자에게 이미 익숙한 서비스고 러닝커브가 높지 않음
- 서비스 운영 환경인 AWS ECS 는 S3 의 arn 을 사용하여 바로 시스템 변수 적용이 가능함

![](https://i.imgur.com/Gs01GRA.gif)

.

..

...

....

## 이걸로 끝?

이라면 조금 심심하죠? 당연하게도 아직 몇가지 문제가 남아있어요.

### 그래서 어느 버킷에 있나

일반적으로 S3 를 쓰다보면 파일구조 최적화나 비즈니스에 따른 구분 등으로 인해 굉장히 많은 버킷이 생기기 마련이에요.

```bash
aws s3 cp s3://something.service.com/enviroment/.env .env
```

`.env` 파일이 없는 경우 [[AWS CLI]] 를 사용하여 위 명령어처럼 `.env` 파일을 내려받아야 합니다. 미리 버킷 이름을 누군가로부터 공유받지 않으면, 버킷을 모두 뒤져봐야하니 환경변수 파일을 찾기가 쉽지 않을 것 같네요. 공유하는 과정을 없애려고 한건데, 다시 뭔가를 공유 받아야하는 상황은 조금 불편하게 느껴지는 것 같아요.

![](https://i.imgur.com/zoRtk5z.png)

_버킷은 너무 많다. env 야 어딨니...?_

S3 에서 버킷을 탐색하며 다운로드해야할 `.env` 파일을 찾는 과정을 자동화하면 편하겠죠? 이 부분은 fzf 나 gum 등으로 쉽게 스크립트를 작성하는 것도 가능합니다.

### 스프링부트는 시스템 환경변수가 필요하다. `.env` 가 아니라...

이미 눈치채신 분들도 계실지 모르겠지만, 스프링부트는 yaml 파일의 placeholder 에 시스템 환경변수를 읽어서 값을 채우게 되요. 하지만 `.env` 파일만으로는 시스템 환경변수 적용이 되지 않고, 따라서 스프링부트의 초기화 과정에 적용되지 않아요.

실제 동작을 잠깐 살펴볼게요.

```bash
# .env
HELLO=WORLD
```

```yaml
# application.yml
something:
  hello: ${HELLO} # OS 에서 HELLO 라는 환경변수를 찾아서 값을 얻는다.
```

```java
@Slf4j
@Component
public class HelloWorldConfig {

    @Value("${something.hello}")
    private String hello;

    @PostConstruct
    public void init() {
        log.info("Hello: {}", hello);
    }
}
```

![](https://i.imgur.com/2xsaxSq.png)
_null 이 반환된다_

![](https://i.imgur.com/ht8Wkin.png)

`@Value` 의 placeholder 를 해결하지 못하기 때문에 빈이 등록되지 못하고 에러가 발생하는걸 확인할 수 있어요.

![](https://i.imgur.com/5hiC2wG.gif)

_`.env` 파일이 있다고 해서 시스템 환경변수로 등록되진 않는다_

`.env` 파일을 적용하려면 `export` 명령을 실행하거나, 인텔리제이의 런 설정에 `.env` 파일을 등록하면 되요. 하지만 `export` 명령을 사용하는건, 로컬 머신에 너무 많은 **변수가 글로벌로 관리되게 되면서 덮어쓰기 등 의도치 않은 동작을 유발**할 수 있으므로 인텔리제이의 GUI 를 통해 개별로 관리하는걸 추천해요.

![](https://i.imgur.com/qyTR7Vb.png)

_인텔리제이는 `.env` 파일 설정을 GUI 를 통해 지원한다_

![](https://i.imgur.com/9Ef45h1.png)

_placeholder 가 해결되고 정상 적용된걸 확인할 수 있다_

## Answer-최최종-이게진짜.final

휴, 길고 긴 문제 인식과 범위 확정의 과정이 끝났네요. 워크플로우를 마지막으로 한 번 정리해보고 스크립트를 소개할게요.

1. 자동화 스크립트를 통해 s3 에서 적절한 `.env` 를 찾고 다운로드할 수 있도록 한다.
2. `.env` 를 읽어서 시스템 환경변수로 설정하자.

쉘 스크립트는 [gum](https://github.com/charmbracelet/gum) 을 사용하여 최대한 단순하면서도 스타일링이 가능하도록 작성했습니다.

[전체 코드](https://github.com/songkg7/automation-script)

```bash
#!/bin/bash

S3_BUCKET=$(aws s3 ls | awk '{print $3}' | gum filter --reverse --placeholder "Select...") # 1.

# 배포 환경 선택
TARGET=$(gum choose --header "Select a environment" "Elastic Container Service" "EC2")
if [ "$TARGET" = "Elastic Container Service" ]; then
    TARGET="ecs"
else
    TARGET="ec2"
fi

S3_BUCKET_PATH=s3://$S3_BUCKET/$TARGET/

# search env file
ENV_FILE=$(aws s3 ls "$S3_BUCKET_PATH" | grep env | awk '{print $4}' | gum filter --reverse --placeholder "Select...") # 2.

# confirm
if (gum confirm "Are you sure you want to use $ENV_FILE?"); then
    echo "You selected $ENV_FILE"
else
    die "Aborted."
fi

ENV_FILE_NAME=$(gum input --prompt.foreground "#04B575" --prompt "Enter the name of the env file: " --value ".env" --placeholder ".env")
gum spin -s meter --title "Copying env file..." -- aws s3 cp "$S3_BUCKET_PATH$ENV_FILE" "$ENV_FILE_NAME" # 3.

echo "Done."
```

1. `gum filter` 를 사용하여 원하는 s3 bucket 을 선택합니다.
2. `env` 라는 단어가 포함된 항목만 검색하고 `ENV_FILE` 이라는 이름의 변수로 할당합니다.
3. `.env` 파일의 objectkey 를 확정하고 다운로드를 진행합니다.

이 스크립트의 실행 과정을 간단하게 데모영상으로 만들어봤어요.

![](https://i.imgur.com/CWSYRCu.gif)

_Demo_

이후에는 현재 디렉토리로 복사된 `.env` 파일을 먼저 소개했던 방식으로 인텔리제이에 적용해주면 됩니다.

> [!tip] direnv
> [direnv](https://direnv.net/) 와 인텔리제이의 direnv plugin 을 활용하면 더 편하게 적용이 가능합니다.

![](https://i.imgur.com/NSIiPwn.jpeg)

## Conclusion

- 스크립트가 단순하기 때문에 유지보수 편리
- 팀원 반응 매우 좋음
- 개발자도 예쁜걸 좋아한다
- 민감한 Credentials 이라면 AWS Secret Manager 를 이용하자
