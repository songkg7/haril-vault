---
title: HTTPS
date: 2022-08-16T13:23:00
publish: false
aliases: 
tags:
  - http
  - https
  - network
categories: Network
updated: 2025-01-07T00:35
---

# HTTP (HyperText Transfer Protocol)

> 인터넷 상에서 클라이언트와 서버가 자원을 주고 받을 때 쓰는 통신 규약

HTTP 는 텍스트 교환이므로, 누군가 네트워크에서 신호를 가로채면 내용이 노출되는 보안이슈가 존재한다.

이런 보안 문제를 해결해주는 프로토콜이 **'HTTPS'**

# HTTPS (HyperText Transfer Protocol Secure)

> 인터넷 상에서 정보를 암호화하는 SSL protocol 을 사용해 클라이언트와 서버가 자원을 주고 받을 때 쓰는 통신 규약

[[Transport Layer Security|TLS]] 를 사용해 암호화된 연결을 하는 HTTP 를 HTTPS(HTTP Secure)라고 하며, 기본 포트는 80번이 아닌 443번을 쓴다.

HTTPS 는 [[대칭키 & 공개키]] 암호화 방식으로 텍스트를 암호화한다.

## HTTPS 통신 흐름

1. 애플리케이션 서버(A) 를 만드는 기업은 HTTPS 를 적용하기 위해 공개키와 개인키를 만든다.
2. 신뢰할 수 있는 CA 기업을 선택하고, 그 기업에게 내 공개키 관리를 부탁하며 계약을 한다.
3. 계약 완료된 CA 기업은 해당 기업의 이름, A 서버 공개키, 공개키 암호화 방법을 담은 인증서를 만들고 해당 인증서를 CA 기업의 개인키로 암호화해서 A 서버에 제공한다.
4. A 서버는 암호화된 인증서를 갖게 되었다. 이제 A 서버는 A 서버의 공개키로 암호화된 HTTPS 요청이 아닌 요청이 오면, 이 암호화된 인증서를 클라이언트에게 건내준다.
5. 클라이언트가 `main.html` 파일을 달라고 A 서버에 요청했다고 가정하자. HTTPS 요청이 아니기 때문에 A 서버의 정보를 CA 기업의 개인키로 암호화한 인증서를 받게 된다.
6. 브라우저는 해독한 뒤 A 서버의 공개키를 얻게 되었다. 이제 A 서버와 통신할 때는 A 서버의 공개키로 암호화해서 요청을 날리게 된다.

HTTPS 라고 해서 무조건 안전한 것은 아니다. (신뢰받는 CA 기업이 아닌 자체 인증서를 발급한 경우 등)

이때는 HTTPS 지만 브라우저에서 `주의 요함`, `안전하지 않은 사이트` 와 같은 알림으로 주의받게 된다.

> [!info] CA
> Certificate Authority 로, 공개키를 저장해주는 신뢰성이 검증된 민간 기업
> CA 의 공개키는 브라우저가 이미 알고 있다. 세계적으로 신뢰할 수 있는 기업으로 등록되어 있기 때문에, 브라우저가 인증서를 탐색하여 해독이 가능한 것이다.

# Reference

- [[Network]]
- https://velog.io/@alscjf6315/HTTPS-%EC%9D%98-%EB%8F%99%EC%9E%91%EC%9B%90%EB%A6%AC