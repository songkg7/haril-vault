---
title: "[네트워크] 패킷 캡처"
date: 2024-04-10 01:18:00 +0900
aliases: 
tags:
  - network
  - packet
categories: 
updated: 2024-04-13 11:47:38 +0900
---

Mac 을 기준으로 설명합니다.

```bash
brew install httpie termshark
```

```bash
docker run -p 8080:8080 songkg7/rest-server
```

```bash
http localhost:8080/ping
```

패킷 분석 툴로는 좀 더 범용적인 wireshark 를 사용하려 했으나 설치가 안되는 이슈로 부득이하게 termshark 를 사용합니다. termshark 도 충분히 좋은 툴이므로 편하신걸로 사용하시면 되겠습니다.

`ifconfig` 를 통해 현재 머신에 존재하는 네트워크 인터페이스를 확인할 수 있습니다.

```bash
ifconfig
tshark -D
```

![](https://i.imgur.com/NjtA2p3.png)

`lo0` 라는 이름으로 존재하네요. 이제 이 장비에 오고가는 패킷을 dump 해보겠습니다.

```bash
sudo tcpdump -v -i lo0 -w test.pcap
sudo tshark -i lo0 -w test.pcap
```

tcpdump 를 실행하면 network packet 을 캡쳐하는 상태로 진입합니다. 다른 터미널 세션에서 [[Loopback]] 으로 요청을 보내고,

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
