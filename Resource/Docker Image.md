---
title: docker image
date: 2023-10-13 20:58:00 +0900
aliases: 
tags:
  - docker
  - container
  - image
  - study
categories: 
updated: 2023-10-13 21:42:28 +0900
related: "[[Docker|Docker]]"
---

도커 이미지는 논리적으로는 하나의 대상(애플리케이션 스택 전체가 하나로 압축된 파일과 비슷)이다. 이미지를 내려받는 과정을 보면 여러 건의 파일을 동시에 내려받는 다는 점에서 단일 파일을 내려받는 과정이 아니라는 것을 알 수 있다. 이들 각각의 파일을 이미지 레이어라고 부른다. 도커 이미지는 물리적으로는 여러 개의 작은 파일로 구성되어 있고 도커가 이들 파일을 조립해 컨테이너 내부 파일 시스템을 만든다.

도커 이미지는 설정값의 기본값을 포함해 패키징되지만, 컨테이너를 실행할 때 이 설정값을 바꿀 수 있다.

호스트 컴퓨터에도 고유의 환경 변수가 있다. 그러나 호스트 컴퓨터의 환경 변수는 컨테이너와는 별개다. 컨테이너는 도커가 부여한 환경 변수만을 갖는다.

## Dockerfile 작성하기

[[Dockerfile]] 은 애플리케이션을 패키징하기 위한 간단한 스크립트다. Dockerfile 은 일련의 인스트럭션으로 구성돼 있는데, 인스트럭션을 실행한 결과로 도커 이미지가 만들어진다.

```dockerfile
FROM diamol/node

ENV TARGET="blog.sixeyed.com"
ENV METHOD="HEAD"
ENV INTERVAL="3000"

WORKDIR /web-ping
COPY app.js .

CMD ["node", "/web-ping/app.js"]
```

## 컨테이너 이미지 빌드하기

```bash
docker image build --tag web-ping .
```

```bash
# w 로 시작하는 태그명을 가진 이미지 목록을 확인한다
docker image ls 'w*'
```

```bash
docker container run -e TARGET=docker.com -e INTERVAL=5000 web-ping
```

## 도커 이미지와 이미지 레이어 이해하기

도커 이미지에는 패키징에 포함시킨 모든 파일이 들어 있다. 이들 파일은 나중에 컨테이너의 파일 시스템을 형성한다. 이 외에도 이미지에는 자신에 대한 여러 메타데이터 정보도 들어 있다. 이 정보를 이용하면 이미지를 구성하는 각 레이어는 무엇이고 이들 레이어가 어떤 명령으로 빌드됐는지 알 수 있다.

```bash
docker image history redis
```

```
IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
da63666bbe9a   3 weeks ago   /bin/sh -c #(nop)  CMD ["redis-server"]         0B
<missing>      3 weeks ago   /bin/sh -c #(nop)  EXPOSE 6379                  0B
<missing>      3 weeks ago   /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B
<missing>      3 weeks ago   /bin/sh -c #(nop) COPY file:e873a0e3c13001b5…   661B
<missing>      3 weeks ago   /bin/sh -c #(nop) WORKDIR /data                 0B
<missing>      3 weeks ago   /bin/sh -c #(nop)  VOLUME [/data]               0B
<missing>      3 weeks ago   /bin/sh -c mkdir /data && chown redis:redis …   0B
<missing>      3 weeks ago   /bin/sh -c set -eux;   savedAptMark="$(apt-m…   58.8MB
<missing>      3 weeks ago   /bin/sh -c #(nop)  ENV REDIS_DOWNLOAD_SHA=5c…   0B
<missing>      3 weeks ago   /bin/sh -c #(nop)  ENV REDIS_DOWNLOAD_URL=ht…   0B
<missing>      3 weeks ago   /bin/sh -c #(nop)  ENV REDIS_VERSION=7.2.1      0B
<missing>      3 weeks ago   /bin/sh -c set -eux;  savedAptMark="$(apt-ma…   4.12MB
<missing>      3 weeks ago   /bin/sh -c #(nop)  ENV GOSU_VERSION=1.16        0B
<missing>      3 weeks ago   /bin/sh -c groupadd -r -g 999 redis && usera…   4.3kB
<missing>      3 weeks ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      3 weeks ago   /bin/sh -c #(nop) ADD file:a1398394375faab8d…   74.8MB
```

`CREATED BY` 항목은 해당 레이어를 구성항 Dockerfile 스크립트의 인스트럭션이다. Dockerfile 인스트럭션과 이미지 레이어는 1:1 관계를 갖는다. 이미지 레이러를 제대로 이해해야 도커를 효율적으로 활용할 수 있다.

도커 이미지는 이미지 레이어가 모인 논리적 대상이다. 레이어는 도커 엔진의 캐시에 물리적으로 저장된 파일이다. 이 점이 왜 중요하냐면, 이미지 레이어는 여러 이미지와 컨테이너에서 공유되기 때문이다. 만약 Node.js 애플리케이션이 실행되는 컨테이너를 여러 개 실행한다면 이들 컨테이너는 모두 Node.js 런타임이 들어 있는 이미지 레이어를 공유한다.

따라서 다른 이미지와 레이어를 공유하면 실제로는 디스크 용량을 훨씬 덜 차지한다. 이미지 목록 확인에서는 논리적 용량이므로 정확한 수치를 확인할 수 없지만, 다른 명령으로 확인할 수 있다.

```bash
docker system df
```

```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          6         0         809.6MB   809.6MB (100%)
Containers      0         0         0B        0B
Local Volumes   10        0         762.2MB   762.2MB (100%)
Build Cache     0         0         0B        0B
```

이미지 레이어를 여러 이미지가 공유한다면, 공유되는 레이어는 수정할 수 없어야 한다. 만약 이미지의 레이어를 수정할 수 있다면 그 수정이 레이어를 공유하는 다른 이미지에도 영향을 미치게 된다. **도커는 이미지 레이어를 읽기 전용으로 만들어 두어 이런 문제를 방지**한다. 이미지를 빌드하면서 레이어가 만들어지면 레이어는 다른 이미지에서 재사용될 수 있다. 그러나 레이어를 수정할 수는 없다. 이 점은 Dockerfile 스크립트를 최적화해 도커 이미지의 용량을 줄이고 빌드를 빠르게 만드는 기법에서 특히 잘 활용된다.

## 이미지 레이어 캐시를 이용한 Dockerfile 스크립트 최적화

Dockerfile 스크립트의 인스트럭션은 각각 하나의 이미지 레이어와 1:1로 연결된다. 그러나 인스트럭션의 결과가 이전 빌드와 같다면, 이전에 캐시된 레이어를 재사용한다. 이런 방법으로 똑같은 인스트럭션을 다시 실행하는 낭비를 줄일 수 있다.

도커는 캐시에 일치하는 레이어가 있는지 확인하기 위해 [[Hash]] 값을 이용한다. 해시값은 Dockerfile 스크립트의 인스트럭션과 인스트럭션에 의해 복사되는 파일의 내용으로부터 계산되는데, 기존 이미지 레이어에 해시값이 일치하는 것이 없다면 캐시 미스가 발생하고 해당 인스트럭션이 실행된다. **한번 인스트럭션이 실행되면 그 다음에 오는 인스트럭션은 수정된 것이 없더라도 모두 실행**된다.

이러한 연유로 Dockerfile 스크립트의 **인스트럭션은 잘 수정하지 않는 인스트럭션이 앞으로 오고 자주 수정되는 인스트럭션이 뒤에 오도록 배치**돼야 한다. 이렇게 해야 캐시에 저장된 이미지 레이어를 되도록 많이 재사용할 수 있다. 이미지를 공유하는 과정에서 시간은 물론이고 디스크 용량, 네트워크 대역폭을 모두 절약할 수 있는 방법이다.

이제 위쪽의 Dockerfile 을 최적화해보자.

CMD 인스트럭션은 스크립트 마지막에 배치할 필요가 없다. 이 인스트럭션은 FROM 인스트럭션 뒤라면 어디에 배치해도 무방하다. 또한, 수정할 일이 잘 없으므로 초반부에 배치하면 된다. 그리고 ENV 인스트럭션 하나로 여러 개의 환경 변수를 정의할 수 있으므로 세 개의 ENV 인스트럭션을 하나로 합칠 수 있다.

```dockerfile
FROM diamol/node

CMD ["node", "/web-ping/app.js"]

ENV TARGET="blog.sixeyed.com"
    METHOD="HEAD"
    INTERVAL="3000"

WORKDIR /web-ping
COPY app.js .
```

이제 다시 빌드해보면 마지막 단계를 제외하고는 모든 레이어를 캐시에서 재사용한다. 우리가 원하는 최적화가 바로 이런 것이다.

## Conclusion

- 적절하게 인스트럭션을 배치하여 Dockerfile 스크립트의 최적화
- 이식성 있는 이미지를 만들기
