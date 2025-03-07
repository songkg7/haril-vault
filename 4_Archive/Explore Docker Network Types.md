---
title: 도커의 네트워크 타입들
date: 2024-06-16T16:54:00
aliases: 
tags:
  - docker
  - network
  - study
categories: 
updated: 2025-02-02T21:44
published: 2025-02-02
---

## Docker 의 네트워크 관리

docker 의 네트워크 타입은 총 6가지가 있다.

- Bridge
- Host
- IPvlan
- MACvlan
- Overlay
- None

아마 많은 백엔드 개발자들은 네트워크 타입에 대해서 잘모르거나, 알아도 bridge 만 쓰고 있을거라 생각한다.

이번 글을 통해서 하나씩 알아보자. [[Orbstack]] 으로 VM 을 실행하여 실습을 진행한다.

```bash
orb create ubuntu
ssh orb
# ip addr show 를 실행하여 네트워크 인터페이스 설정 확인
sudo apt install docker.io -y
# ip addr show 를 실행하여 네트워크 인터페이스 설정 확인, docker0 인터페이스가 추가.
sudo gpasswd -a $USER docker # sudo 를 생략하기 위해 현재 유저에 docker 실행 권한 추가
```

![](https://i.imgur.com/Eu3w1T0.png)

![](https://i.imgur.com/wf6vS1n.png)

docker0 인터페이스는 도커의 기본 네트워크 인터페이스이며, 브릿지로 동작한다.

![[docker-network-arch.excalidraw]]

```bash
# docker network interface 목록
docker network ls
```

## Default Network (bridge)

![](https://i.imgur.com/0m7hPgu.png)

서비스를 하나 실행시킨 후 네트워크 상태를 다시 확인해보자

```bash
docker run -itd --rm --name one busybox
ip addr show
```

![](https://i.imgur.com/B2BuLb0.png)

docker0 인터페이스에 연결된 것을 볼 수 있다. 몇 가지 서비스를 더 실행해보자.

```bash
docker run -itd --rm --name two busybox
docker run -itd --rm --name web nginx
ip addr show
```

![](https://i.imgur.com/cuV2zBx.png)

컨테이너간 통신을 테스트해보기 위해 IP 를 우선 출력해보자.

```bash
# IP 확인
docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress}}' {container_name}
# 172.17.0.3
```

```bash
docker exec -it one sh
ping google.com
```

외부 네트워크와는 통신이 가능하다.

```bash
ping 172.17.0.3
# 통신 가능
```

아까 미리 nginx 를 실행시켜뒀다. 이 nginx 에는 접근할 수 있을까? ubuntu 의 IP 였던 198.19.249.147 로 접근해보자.

![](https://i.imgur.com/GfDg2OA.png)

컨테이너에 접근하려면 포트가 매핑되어 있어야 한다. 컨테이너 포트를 호스트 머신의 포트 80에 연결해보자.

```bash
docker run -itd --rm --name web -p 80:80 nginx
```

![](https://i.imgur.com/souVECS.png)

![](https://i.imgur.com/KapxOIK.png)

이 정도면 충분히 사이드 프로젝트를 배포하고 외부에 공개할 수 있다. 하지만 도커에서는 default 네트워크 사용을 권장하지 않는다. 그리고 앞으로 알아볼 user-defined network 를 사용하도록 권장한다. 왜 그럴까?

## User-defined bridge

docker 에서 유저 정의 네트워크를 사용하는 것은 매우 쉽다.

```bash
docker network create numbers
```

기본적으로 브릿지 타입으로 생성된다.

```bash
ip addr show
```

![](https://i.imgur.com/zxhdBGW.png)

가상의 네트워크 장비가 하나 추가된 것을 볼 수 있다. 네트워크 서브넷은 172.18.0.1/16 을 할당하고 있다.

몇 개의 서비스를 추가하고 네트워크를 살펴보자.

```bash
docker run -itd --rm --name three --network numbers busybox
docker run -itd --rm --name four --network numbers busybox
```

![](https://i.imgur.com/kvd8goV.png)

```bash
docker inspect numbers
```

![](https://i.imgur.com/4A9mUbg.png)

네트워크에 속한 컨테이너들의 정보를 확인할 수 있다. 도대체 왜 이렇게 사용해야할까?

그 이유는 default 네트워크로부터 완전히 격리할 수 있기 때문이다. one 에 접근해서 three 로 ping 을 날려보자.

![](https://i.imgur.com/F9DZ0Q2.png)

two 로 ping 을 날리던 때와는 달리 통신되지 않는다. 하지만 three 는 four 와 여전히 통신할 수 있다.

![](https://i.imgur.com/GCsBQ4F.png)

네트워크 간 상호 격리는 굉장히 중요한 기능이다.

두 번째로는 DNS resolve 기능을 제공해주기 때문이다. 같은 사용자 정의 네트워크에 속해있다면, 아이피가 아닌 컨테이너 이름으로도 통신할 수 있다.

![](https://i.imgur.com/PfiY7qi.png)

이 DNS 기능은 매우 편리한데, 컨테이너 환경에서는 수시로 서비스가 재시작되거나 배포될 수 있기 때문이다. 컨테이너는 생성될 때마다 아이피가 변하게 되는데, DNS 가 아닌 IP 로 통신한다면 수시로 애플리케이션 설정을 바꿔야할지도 모른다.

### user-defined network 를 사용해야하는 이유

- default network 로부터 격리된 환경 구성가능
- DNS resolution

## Host

포트를 매핑하지 않고 컨테이너의 서비스를 외부에 노출할 수 없을까?

```bash
docker run -itd --rm --name web --network host nginx
```

포트를 노출하는대신 host 네트워크를 사용하도록 한다. 호스트 머신과 컨테이너 간의 네트워크 격리가 없으며 가상 인터페이스가 없다. docker 없이 실행되는 것처럼 이 컨테이너를 실행하므로 컨테이너 내부의 서비스에 직접 접근할 수 있다.

![](https://i.imgur.com/pdGZBr1.png)

도커 컨테이너의 서비스가 호스트와 격리되지 않고 포트 스캐닝에 그대로 노출되기 때문에 보안 문제가 발생할 수 있는 점은 주의해야 한다. 포트 스캐닝의 위험성은 지난 번 [[Nmap]] 을 살펴보면서 알아보았으니 생략.

## IPvlan

> IPvlan networks give users total control over both IPv4 and IPv6 addressing. The VLAN driver builds on top of that in giving operators complete control of layer 2 VLAN tagging and even IPvlan L3 routing for users interested in underlay network integration.

전통적으로 컨테이너는 브릿지를 사용하여 외부 네트워크와 통신한다. 이것은 잘 동작하지만 네트워크 구성에 복잡성을 추가한다. 또한 네트워크 홉이 추가되어 성능적인 패널티를 갖게 된다.

![](https://i.imgur.com/fr7JZI8.png)

IPvlan 은 네트워크 가상화 테크닉이다. 사용자에게 IPv4 및 IPv6 주소 지정에 대해 완전한 제어권을 제공한다. 네트워크 격리를 위해 브릿지를 사용하지 않고, 호스트 네트워크 장비에 직접 연결하여 매우 가벼운 네트워크 구성이 가능하다. 따라서 포트 매핑이 필요하지 않다.

- 고성능 네트워킹
- 보안 격리

```bash
docker network create -d ipvlan \
    --subnet=198.19.249.0/24 \
    --gateway=198.19.249.1 \
    -o ipvlan_mode=l2 \
    -o parent=eth0 my-ipvlan-net
```

```bash
docker run -itd --rm --name web --network my-ipvlan-net nginx
```

![](https://i.imgur.com/kdKrXYx.png)

_네트워크 인터페이스를 생성하지 않는다._

198.19.249.2 로 접근하면 nginx 페이지가 보이는걸 확인할 수 있다.

## MACvlan

> Macvlan networks allow you to assign a MAC address to a container, making it appear as a physical device on your network. The Docker daemon routes traffic to containers by their MAC addresses. Using the `macvlan` driver is sometimes the best choice when dealing with legacy applications that expect to be directly connected to the physical network, rather than routed through the Docker host's network stack.

![](https://i.imgur.com/PV3WpG8.png)

MACvlan 을 사용하면 컨테이너에 MAC 주소를 할당하여 네트워크에서 물리적 장치로 보이게 할 수 있다. 도커 데몬은 MAC 주소를 기준으로 트래픽을 컨테이너로 라우팅하게 된다. 도커 호스트의 네트워크 스택을 통해 라우팅되지 않고 물리적 네트워크에 직접 연결될 것으로 예상되는 레거시 애플리케이션을 처리할 때 도움이 될 수 있다.

한 가지 예를 들어보자. 웹 서비스를 구성하고 대용량 파일을 다운로드 받아서 그것을 사용하려고 한다고 해보자. 파일의 용량은 수 백 기가바이트에 달할 수 있지만, 사용하는 서버는 하나이다.

서버에 랜카드가 하나만 있다면 문제가 생길 수 있다. 이는 너무 많은 리소스를 사용할 수 있기 때문이다. 그리고 1Gbps 로 통신한다면, 이 작업에 걸리게 되는 시간은 굉장히 길어질 것이며, 그러므로 제공하는 웹 서비스도 항상 속도가 낮아질 것이다.

그러므로 4개의 인터페이스를 모두 바라보도록 설정하면 된다. 이때 MAC address 는 모두 다르게 설정해주어야 한다. 이것을 가능케 해주는 기술이 macvlan 이다.

```bash
docker network create -d macvlan \
    --subnet=192.168.1.0/24 \
    --gateway=192.168.1.1 \
    -o parent=eth0 macvlan_net
```

- `-d macvlan`: Macvlan 드라이버를 사용하여 네트워크를 생성합니다.
- `--subnet`: 네트워크의 서브넷을 지정합니다.
- `--gateway`: 기본 게이트웨이를 지정합니다.
- `-o parent`: 호스트의 실제 네트워크 인터페이스를 지정합니다 (여기서는 `eth0`).

```bash
docker run -itd --rm --network macvlan_net --name five busybox
```

```bash
docker exec -it five sh
ip addr
# mac 주소가 host 와 다른 것을 확인할 수 있음
```

### mode

- bridge : 기본 모드. 컨테이너가 서로 및 외부 네트워크와 통신할 수 있음. 호스트와 직접 통신은 불가능하지만 별도의 macvlan 인터페이스를 호스트에 추가하여 통신할 수 있음
- 802.1q : vlan 태깅을 통해 네트워크를 분리. 멀티테넌트 환경에서 유용. 각 vlan 에 대해 별도의 서브넷을 할당할 수 있음

**장점**:

- 네트워크 성능이 우수합니다.
- 컨테이너가 고유한 MAC 주소를 가져 네트워크에서 독립된 엔티티로 동작합니다.
- 네트워크 분리가 가능하여 보안성이 높습니다.

**단점**:

- 호스트와의 직접 통신이 제한될 수 있습니다.
- 네트워크 구성 및 관리가 복잡할 수 있습니다.
- 일부 네트워크 환경에서는 사용이 제한될 수 있습니다.

## Overlay

여러 호스트에 분산되어 돌아가는 컨테이너들 간의 네트워킹을 위해서 사용된다. 예를 들어 docker swarm 의 경우 하나의 호스트가 아닌 여러 호스트로 클러스터를 구성하게 되는데 이 때 클러스터 내부의 컨테이너들 간의 네트워크 통신을 위해 overlay 네트워크가 설정된다.

![](https://i.imgur.com/aaZV4VO.png)

만약 운영환경에서 overlay 네트워크를 써야한다면 [[Kubernetes]] 를 사용하는 편이 더 낫다.

ubuntu 를 2개 준비하여 데모를 시연할 수 있음.

```bash
# node 1
docker swarm init
```

## None

![](https://i.imgur.com/FURiKXn.png)

네트워크 설정이 존재하지 않는다. 따라서 완전히 격리되어 있으며  루프백 인터페이스만 존재하게 된다.

- 루프백 인터페이스만 존재하여 외부의 어떤 접근도 불가능하다.
- batch job 이나 데이터 프로세싱을 위한 컨테이너에 유용하다.

```bash
docker run -itd --rm --name batch --network none busybox
docker exec -it batch sh
ip addr
```

## Conclusion

- 도커 네트워크의 종류와 사용법에 대해서 간략하게 살펴봤다. 
- 각각의 네트워크 타입을 언제 사용해야하는지 도움이 되었길 바란다.

## Reference

- https://docs.docker.com/network/
