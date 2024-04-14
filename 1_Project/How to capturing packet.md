---
title: "[네트워크] 패킷 캡처"
date: 2024-04-10 01:18:00 +0900
aliases: 
tags:
  - network
  - packet
categories: 
updated: 2024-04-14 12:25:59 +0900
---

## 네트워크 패킷이란

데이터를 네트워크로 전송하기 위해서는 어떻게 해야할까요? 상대방과 커넥션을 생성한 후, 데이터를 한 번에 보내는 방법이 가장 직관적인 방법일 겁니다. 하지만 이런 방법은 여러 요청을 처리해야할 때 비효율이 발생하는데요, 하나의 커넥션으로는 하나의 데이터 전송만 유지할 수 있기 때문입니다. 만약 큰 데이터가 전송되느라 커넥션이 길어진다면 다른 데이터들이 기다려야하겠죠.

네트워크는 데이터 전송 과정을 최대한 효율적으로 처리하기 위해 데이터를 여러 조각으로 나눈 후, 수신 측에서 조립하도록 했습니다. 이 **조각난 데이터 구조체**를 패킷이라고 부릅니다. 패킷에는 수신 측에서 데이터를 순서대로 조립할 수 있도록 여러 추가 정보를 포함하고 있습니다.

이렇게 여러 패킷으로 전송되면 중간에 데이터가 유실되거나, 정확한 순서로 전달되지 않거나 하는 등의 다양한 에러를 만나게 될 수 있습니다. 우리는 이런 문제를 어떻게 디버깅할 수 있을까요? 🤔

## 어떻게 확인할 수 있을까?

네트워크 동작은 커널에 의해 가려져있는 부분이기 때문에 효과적인 디버깅을 위해서 패킷을 분석할 수 있는 도구는 필수적입니다. 당연히도 이미 많은 도구들이 제공되고 있어요. wireshark 가 대표적입니다.

하지만 이번 글에서는 wireshark 같은 **GUI 를 사용하지 못하는 환경에서도 패킷을 분석할 수 있는 방법**을 소개해보려고 해요. wireshark 의 TUI 버전인 `tshark` 와 `termshark` 를 사용할겁니다. 사용법이 복잡하지 않기 때문에 간편하게 네트워크를 분석할 수 있습니다.

## 설치 및 사용법

Mac 을 기준으로 설명하기 때문에 설치는 `brew` 로 진행합니다.

```bash
brew install httpie termshark
```

먼저 패킷을 확인하려면 어떤 네트워크 장비를 통해 오고가는 패킷을 캡쳐할건지 지정해줘야 합니다. `ifconfig` 를 통해 현재 머신에 존재하는 네트워크 인터페이스를 확인할 수 있습니다.

```bash
ifconfig
tshark -D
```

![](https://i.imgur.com/NjtA2p3.png)

`lo0` 라는 루프백 인터페이스가 존재하네요. 이제 이 장비에 오고가는 패킷을 dump 해보겠습니다.

```bash
sudo tcpdump -v -i lo0 -w test.pcap
sudo tshark -i lo0 -w test.pcap
```

tcpdump 를 실행하면 network packet 을 캡쳐하는 상태로 진입합니다. 다른 터미널 세션에서 [[Loopback]] 으로 요청을 보내고,

```bash
docker run -p 8080:8080 songkg7/rest-server
```

```bash
http localhost:8080/ping
```

```bash
http localhost:8080/ping
```

tcpdump 를 실행한 세션에서는 `ctrl + c` 를 눌러 캡쳐를 종료합니다.

> [!NOTE] 루프백(Loopback)이란?
> Contents

![](https://i.imgur.com/f7cGNTK.png)

```bash
termshark -r test.pcap tcp.port==8080
```

![](https://i.imgur.com/9R32wPz.png)

색상은 wireshark 룰을 따릅니다.

- 회색: TCP SYN/FIN
- 녹색: HTTP
- 붉은색: ABORT

패킷 분석 방법에 익숙해지셨길 바랍니다...!

### 알 수 있는 내용

- 클라이언트는 커넥션을 생성할 때 매번 새로운 포트를 사용
- Flags 는 0, 1 의 비트를 사용해서 표시
- SYN 과정에서 시퀀스 넘버 설정

### 추가

- `tcpdump` 를 대체할 수 있는 `tshark` 를 사용해보세요. wireshark 의 공식 cli 입니다.

---

지금까지는 loopback interface 를 사용하여 실험한 것이기 때문에 좀 더 실무적인 측면에서 접근해보기 위해 외부 API 를 호출해볼게요.

바로 현재까지처럼 과정을 진행하면 너무 많은 네트워크 패킷의 존재로 인해 뭐가 뭔지 알기가 힘들다. 필터링하기 위해 뭘 알아야할까? 바로 상대방의 IP 에요.

### 상대 IP 확인

```bash
ping {url}
```

상대 ip 로 필터링하면 결과가 나온다. source ip 의 경우는 뭔가 낯설다. 어디서 튀어나온 IP 일까?

### 자기 IP 확인

```bash
ifconfig | grep 'inet '
```

루프백, 이더넷 및 wi-fi 가 함께 나온다. 어딘가에 메모해두자.

### 패킷 분석

이제는 https 로 요청을 보냈기 때문에 [[Transport Layer Security|TLS]] 라는 키워드가 등장한다. body 가 인코딩된 것을 확인할 수 있고 내용을 볼 수 없다.

- 항상 RST 로 연결을 종료하는 것을 볼 수 있는데 정확한 이유를 아직 모르겠다.

## Reference

- https://www.cloudflare.com/ko-kr/learning/network-layer/what-is-a-packet/
