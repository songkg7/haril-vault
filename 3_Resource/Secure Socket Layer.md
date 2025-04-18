---
title: Secure Socket Layer
date: 2023-11-01T09:58:00
aliases:
  - SSL
tags:
  - security
  - socket
  - network
categories: 
updated: 2025-01-07T00:35
---

## SSL 이란

SSL (Secure Socket Layer)은 웹사이트와 클라이언트 간에 데이터를 보호하기 위해 사용되는 암호화 프로토콜입니다. SSL은 인터넷 통신에서 데이터의 안전성과 무결성을 보장하기 위해 사용됩니다.

일반적으로, 웹사이트와 클라이언트 간에 데이터를 전송할 때, 데이터는 암호화되지 않은 상태로 전송됩니다. 이러한 경우, 해커나 악의적인 개체가 중간에 개입하여 데이터를 도청하거나 조작할 수 있습니다. SSL은 이러한 위험을 방지하기 위해 데이터를 암호화하고 인증하는 역할을 합니다.

SSL을 사용하는 웹사이트는 HTTPS (HTTP Secure) 프로토콜을 사용하여 데이터를 전송합니다. HTTPS는 HTTP와 SSL을 결합한 것으로, 웹사이트 주소가 "https://"로 시작하며, 브라우저에서 보안 잠금 아이콘과 함께 안전한 연결임을 나타냅니다.

SSL은 공개키 기반 암호화 방식을 사용하여 작동합니다. 서버는 공개키와 개인키 쌍을 생성하고, 공개키는 클라이언트에게 제공됩니다. 클라이언트가 서버에 접속하면, 서버는 공개키를 사용하여 세션 키를 암호화하여 클라이언트에게 전송합니다. 클라이언트는 이 암호화된 세션 키를 개인키로 복호화하여 사용하여 데이터를 암호화하고 서버에 전송합니다.

SSL은 데이터의 안전성을 보장하기 위해 인증서도 사용합니다. 인증서는 웹사이트의 신원을 확인하는 역할을 합니다. 신뢰할 수 있는 인증기관 (CA)에서 발급한 인증서는 웹사이트의 도메인과 공개키를 포함하고 있으며, 클라이언트는 이 인증서를 사용하여 웹사이트가 신뢰할 수 있는지 확인합니다.

SSL은 온라인 거래, 개인 정보 보호, 로그인 등 민감한 정보의 안전한 전송을 보장하는데 사용됩니다. SSL은 웹사이트와 클라이언트 간에 안전한 연결을 제공하여 중간자 공격과 데이터 도청을 방지하고, 사용자들에게 더 안전한 온라인 환경을 제공합니다.
