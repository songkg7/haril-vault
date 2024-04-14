---
title: 패킷으로 알아보는 3 way handshake with Termshark
date: 2024-04-10 01:18:00 +0900
aliases: 
tags:
  - network
  - packet
  - tshark
  - termshark
  - wireshark
categories: 
updated: 2024-04-14 21:31:41 +0900
---

## 네트워크 패킷이란

데이터를 네트워크로 전송하기 위해서는 어떻게 해야할까요? 상대방과 커넥션을 생성한 후, 데이터를 한 번에 보내는 방법이 가장 직관적인 방법일 겁니다. 하지만 이런 방법은 여러 요청을 처리해야할 때 비효율이 발생하는데요, 하나의 커넥션으로는 하나의 데이터 전송만 유지할 수 있기 때문입니다. 만약 큰 데이터가 전송되느라 커넥션이 길어진다면 다른 데이터들이 기다려야하겠죠.

네트워크는 데이터 전송 과정을 최대한 효율적으로 처리하기 위해 데이터를 여러 조각으로 나눈 후, 수신 측에서 조립하도록 했습니다. 이 **조각난 데이터 구조체**를 패킷이라고 부릅니다. 패킷에는 수신 측에서 데이터를 순서대로 조립할 수 있도록 여러 추가 정보를 포함하고 있습니다.

이렇게 여러 패킷으로 전송되면 패킷 스위칭을 통해 많은 요청을 효율적으로 처리할 수 있지만, 중간에 데이터가 유실되거나, 정확한 순서로 전달되지 않거나 하는 등의 다양한 에러를 만나게 될 수 있습니다. 우리는 이런 문제를 어떻게 디버깅해야 할까요? 🤔

## Wireshark? No...! 이제는 Termshark!

네트워크 동작은 커널에 의해 가려져있는 부분이기 때문에 효과적인 디버깅을 위해서 패킷을 분석할 수 있는 도구는 필수적입니다. 당연히도 이미 많은 도구들이 제공되고 있어요. wireshark 가 대표적입니다.

하지만 이번 글에서는 wireshark 같은 **GUI 를 사용하지 못하는 환경에서도 패킷을 분석할 수 있는 방법**을 소개해보려고 해요. wireshark 의 TUI 버전인 `termshark` 를 사용할겁니다. 사용법이 복잡하지 않기 때문에 간편하게 네트워크를 분석할 수 있습니다.

## 설치 및 사용법

Mac 을 기준으로 설명하기 때문에 설치는 `brew` 로 진행합니다.

```bash
brew install termshark
```

먼저 패킷을 확인하려면 어떤 네트워크 장비를 통해 오고가는 패킷을 캡처할건지 지정해야 합니다. `tshark` 를 통해 현재 머신에 존재하는 네트워크 장비를 확인할 수 있습니다.

```bash
termshark -D
```

![](https://i.imgur.com/irHG3bQ.png)

`ifconfig` 라는 기본 명령어로도 확인할 수 있습니다.

```bash
ifconfig
```

![](https://i.imgur.com/NjtA2p3.png)

우리가 이번 테스트에서 사용할 네트워크 장비는 루프백 인터페이스(localhost)입니다. 출력 결과를 살펴보니 `lo0` 라는 루프백 인터페이스가 존재하네요. 아래 명령을 통해 네트워크 패킷을 캡쳐합니다.

```bash
termshark -i lo0 -w test.pcap # 패킷을 캡쳐하여 test.pcap 이라는 파일로 생성
```

termshark 를 실행하면 network packet 을 캡쳐하는 상태로 진입합니다.

음... 루프백 인터페이스는 localhost 로 네트워크 요청을 보내면 될테니 로컬에서 실행 중인 애플리케이션이 하나 필요할 것 같네요. 터미널 창을 하나 더 열고, [[Docker]] 를 사용해서 실행해줍시다.

```bash
docker run -d -p 8080:8080 songkg7/rest-server
```

이 서버는 `/ping` 이라는 엔드포인트로 GET 요청이 오면 pong 이라는 문자열을 반환하는 간단한 server application 입니다. 메세지가 짧긴 하지만 패킷 동작을 간단하게 살펴보긴 충분할거에요.

이제 [[Loopback]] 으로 요청을 보내고,

> [!info] http 명령은 Httpie 를 사용합니다.
> `Httpie` 가 설치되어 있지 않다면 `curl` 을 대신 사용하거나, `brew install httpie` 로 설치해주세요.

```bash
http localhost:8080/ping
```

termshark 를 실행한 세션에서는 `ctrl + c` 를 눌러 캡쳐를 종료합니다. `la` 를 찍어보면 `test.pcap` 이라는 파일이 생성된 것을 확인할 수 있습니다.

![](https://i.imgur.com/f7cGNTK.png)

## 패킷 분석

이제 패킷 캡쳐 과정은 모두 완료되었어요. 캡쳐 과정 동안 어떤 요청이 오고갔는지 살펴봅시다! 그냥 열어보면 정보량이 너무 많을 수 있으니, 아래처럼 필터링 조건을 지정해서 열면 보고 싶은 요청만 볼 수 있습니다.

```bash
termshark -r test.pcap tcp.port==8080 # 8080 포트로 오고간 패킷만 확인
```

![](https://i.imgur.com/9R32wPz.png)
_Boom!! 💣_

Termshark 는 기본적으로 아래 키로 조작할 수 있어요.

- 방향키 or hjkl : 커서 이동
- `tab`: window 간 focus 이동
- `?`: 도움말
- `/` : filter, `tcp.port==8080` 등으로 원하는 것만 볼 수 있다.
- `q`: 종료

색상 팔레트는 wireshark 와 공유하며 기본 설정으로도 충분히 직관적으로 시각화해줍니다. 만약 색상을 변경하고 싶다면 wireshark 의 설정을 만져주면 되지만, 이 글의 주제와는 약간 벗어나므로 생략할게요.

다시 패킷 이야기로 돌아가서, 패킷 덤프로는 정말 많은 정보를 얻을 수 있지만 중요한 몇가지만 살펴볼게요. 기본적인 TCP 동작 흐름은 아래 이미지처럼 진행됩니다.

![](https://i.imgur.com/qiDbLAK.png)

먼저, 가장 상단을 보면 SYN -> SYN, ACK -> ACK 로 이어지는 3 way handshake 과정을 볼 수 있어요. 이 과정이 진행된 후에 커넥션이 ESTABLISHED 상태가 되며 연결이 수립됩니다.

좀 더 자세히 살펴보면 상대와 어디까지 데이터를 주고 받았는지 알기 위해 초기 과정에서 시퀀스 넘버를 주고 받는 것도 확인할 수 있어요.

![](https://i.imgur.com/HUcOEVH.png)
_SYN 요청에서 client 측 sequence number 를 서버에 건네준다_

SYN 요청을 하며 서버 측에 클라이언트가 설정한 시퀀스 넘버(4175220519)를 전달하고,

![](https://i.imgur.com/ONbTNaM.png)

서버는 클라이언트에 응답을 돌려주며(SYN ACK) 자신의 시퀀스 넘버(1538881812)를 함께 전달해요. Acknowledge Number 는 상대로부터 받아야하는 다음 시퀀스 번호를 의미해요. 서버 입장에서는 클라이언트에게 4175220519 를 받았기 때문에 다음 시퀀스 넘버인 4175220520 을 달라고 하고 있네요.

이제 3 way handshake 의 마지막 패킷인 ACK 를 살펴보면

![](https://i.imgur.com/6wew0fe.png)

시퀀스 넘버로 4175220520 를 전달하려 하고 서버에게 전달받은 시퀀스 넘버인 1538881812 에서 1 증가한 1538881812 + 1 = 1538881813 을 요청하고 있어요. 연결 상태는 CLIENT_ESTABLISHED 로 바뀐 것도 확인할 수 있네요.

> [!NOTE] 시퀀스 넘버가 0부터 시작하지 않는 이유
> 시퀀스 번호가 0이나 1부터 시작하지 않는 이유는 통신 과정에 다른 패킷이 개입하기 어렵도록 하기 위해서입니다. 최초 커넥션 요청시 랜덤한 숫자를 배정함으로써 패킷에 대한 간섭을 방지합니다.

## Conclusion

이렇게 `termshark` 를 통해 간단하게 패킷을 분석할 수 있는 방법에 대해서 살펴봤어요. 이 번 글에서는 분량 조절을 위해 3 way handshake 정도만 살펴봤지만, 패킷 분석을 통해서는 굉장히 풍부한 정보를 얻을  수 있어요. 네트워크 동작에 대해 살펴볼 수 있는 계기가 되었기를 바랍니다.

## Reference

- https://www.cloudflare.com/ko-kr/learning/network-layer/what-is-a-packet/
- https://www.chappell-university.com/post/how-to-wireshark-tcp-conversation-completeness
