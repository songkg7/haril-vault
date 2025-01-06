---
title: Json Web Token
date: 2024-03-10T22:14:00
aliases:
  - JWT
tags:
  - json
  - authentication
categories: 
updated: 2025-01-07T00:35
---

> OpenAI 로 생성된 글입니다.

## JWT 란?

클라이언트와 서버간에 데이터를 주고 받을 때, 두 개체간에 인증을 해야하는 경우가 있습니다. 이때 서버에서는 사용자의 정보를 저장하고 관리하는 세션을 사용하며, 클라이언트는 세션에 대한 식별자인 쿠키를 저장하고 전송합니다. 그러나 이 방식은 서버에서 세션을 관리해야 하므로 로드 밸런싱에 불리합니다. 이런 단점을 해결하기 위해 JWT(JSON Web Token)이 등장한 것입니다.

JWT는 서버와 클라이언트 간의 인증 정보를 JSON 객체로 표준화하여 안정성 있게 전송할 수 있도록 만든 토큰 기반 프로토콜입니다. 이때 토큰은 HS256, RS256 등의 알고리즘으로 암호화되어 있으며, JWT는 종류가 다양하지만 가장 많이 사용되는 형태는 JWT(JSON Web Signature)입니다.

JWT 내부 구조는 다음과 같습니다.

```
헤더(Header).페이로드(Payload).서명(Signature)
```

### Header

헤더에는 토큰 유형과 암호화 알고리즘이 담겨져 있으며 JSON 형태로 인코딩됩니다.

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

Header는 Base64로 인코딩됩니다. 따라서 위의 예제는 다음과 같이 인코딩됩니다.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
```

### Payload

Payload에는 사용자 정보와 토큰 유효기간 등이 담겨져 있으며 JSON 형태로 인코딩됩니다. 서버에서 보내지는 데이터를 저장하기 위해 클라이언트가 생성한 데이터를 담아서 보내고, 클라이언트에서 서버로 보내지는 데이터를 저장하기 위해 서버가 생성한 데이터를 담습니다.

```json
{
  "userId": "1234567890",
  "username": "test",
  "exp": 1588511400
}
```

Payload 역시 Header와 마찬가지로 Base64로 인코딩됩니다. 따라서 위의 예제는 다음과 같이 인코딩됩니다.

```
eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwidXNlcm5hbWUiOiJ0ZXN0IiwiZXhwIjoxNTg4NTEyMTQwLCJpYXQiOjE1ODg2NTcxNDB9
```

보통 기본적으로 정해진 key-value 쌍 외에도 사용자 임의대로 추가할 수 있습니다. 이때 payload에 있는 값들을 클라이언트에서 디코딩하여 사용할 수 있습니다.

### Signature

Signature는 Header와 Payload를 합친 문자열을 Base64로 인코딩한 값입니다. 이후 직접 생성한 header와 payload의 값을 Base64로 인코딩한 후, secret key를 이용해 HS256 알고리즘으로 해싱하면 signature를 얻을 수 있습니다.

```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret
)
```

Signature는 Header와 Payload, Secret key를 조합하여 암호화되어있기 때문에 비밀키가 공개되지 않는다면 서버에서만 토큰이 검증될 수 있습니다. 따라서 Secret key는 외부에 노출되지 않도록 관리해야합니다.

## JWT 동작 방식

1. 클라이언트가 로그인 정보를 서버로 전송합니다.
2. 서버에서 해당 로그인 정보가 유효하다면, 사용자의 id나 username 등의 데이터를 기반으로 JWT 토큰을 생성합니다.
3. 서버에서 생성된 JWT 토큰은 클라이언트로 전송됩니다.
4. 클라이언트는 저장소에 JWT 토큰을 저장하고, 이후 요청마다 Authorization 헤더에 해당 토큰을 담아서 서버로 보냅니다.
5. 요청된 토큰이 유효하다면 서버는 요청을 처리합니다.

## JWT의 장점

- 클라이언트와 서버간 인증 정보를 토큰에 저장하여 세션 관리에 대한 부담을 줄일 수 있습니다.
- 토큰은 종류가 다양하지만 가장 많이 사용되는 JWT(JSON Web Signature)는 표준화되어 있기 때문에 코드의 유지보수가 쉽습니다.

## JWT의 단점

- Payload에 저장하는 데이터가 많아질수록 전체 토큰의 크기가 커지기 때문에 불필요한 데이터가 포함될 수 있습니다. 이 경우 네트워크 비용이 증대될 수 있습니다.
- Base64로 인코딩되어 있기 때문에 토큰을 디코딩하면 사용자 정보가 노출됩니다. 따라서 암호화된 값을 Payload에 담아서 보내도록 해야합니다.
- Secret key를 이용해 암호화하기 때문에 클라이언트에서 직접 수정할 수 없는 경우, 로그인 정보를 수정할 수 없습니다. 이를 방지하기 위해서는 HTTPS로 암호화된 연결을 제공해야합니다.

## Refresh Token

JWT는 일정 기간 또는 로그아웃 시간에 따라 토큰이 만료되기 때문에 유저가 능동적으로 로그아웃하거나 매번 로그인을 하지 않도록 지원하는 기능으로 Refresh Token이 있습니다.

클라이언트는 Access Token과 별도로 발급받은 Refresh Token을 저장합니다. 이후 Access Token이 만료될 때마다 서버에 Refresh Token을 포함한 요청을 보내면 서버에서는 해당 토큰이 유효하다면 새로운 Access Token을 발급해주게됩니다. 이를 통해 클라이언트는 매번 로그인을 하지 않아도 됩니다.

## Refresh Token Rotation

Refresh Token은 Access Token이 만료될 때마다 서버에 Refresh Token을 보내기 때문에 토큰을 탈취당하면 유저의 접근 권한을 오랫동안 유지할 수 있습니다. 따라서 Refresh Token을 새로 발급할 때마다 이전 토큰은 즉시 무효화하는 것이 좋습니다. 이를 Refresh Token Rotation이라고 합니다.

## JWT 사용 예

다음은 JWT를 사용하는 간단한 예입니다. 앞서 언급한 것처럼 JWT는 클라이언트와 서버 간 인증 정보를 JSON 객체로 표준화한 것입니다. 이때 서버에서 클라이언트로 전송되는 데이터는 주로 id나 username 등의 사용자 정보, secret key, 그리고 토큰의 유효 기간 등입니다.

### 로그인 예

1. 클라이언트가 로그인 정보를 서버로 전송합니다.
2. 서버에서 해당 로그인 정보가 유효하다면, 사용자의 id나 username 등의 데이터를 기반으로 JWT 토큰을 생성합니다.
3. 서버에서 생성된 JWT 토큰은 클라이언트로 전송됩니다.
4. 클라이언트는 저장소에 JWT 토큰을 저장하고, 이후 요청마다 Authorization 헤더에 해당 토큰을 담아서 서버로 보냅니다.
5. 요청된 토큰이 유효하다면 서버는 요청을 처리합니다.

### 로그아웃 예

1. 클라이언트에서 로그아웃 요청이 들어오면 서버에서는 JWT 토큰을 받습니다.
2. 서버에서는 전달받은 JWT 토큰을 무효화시킵니다.

### 인가된 사용자 정보 요청 예

1. 클라이언트에서 인가된 사용자 정보를 요청합니다.
2. 이때 Authorization 헤더에 해당 사용자의 JWT 토큰을 담아서 서버로 보냅니다.
3. 서버에서는 전달받은 JWT 토큰을 해석하여 사용자의 정보를 추출합니다.

## Reference

- https://blog.outsider.ne.kr/1160
- [JWT 공식 사이트](https://jwt.io/)
- [JWT 개념 및 동작 방식](https://velopert.com/2389)
