---
title: "PathVariable"
date: 2023-04-20 00:10:00 +0900
aliases: 
tags: 
categories: 
updated: 2023-04-20 00:11:32 +0900
---

[[Spring MVC|Spring MVC]]

@RequestParam 이 있는데도 @PathVariable 을 쓰는 이유에 대해서

URI 경로에 데이터를 넣는 것은 RESTful API 설계에서 일반적인 관행입니다. 다른 방법보다 선호되는 몇 가지 이유가 있습니다.

1.  리소스 식별: URI 경로는 특정 리소스를 식별하는 데 사용됩니다. URI 경로에 데이터를 포함함으로써 클라이언트는 요청하는 리소스를 쉽게 식별할 수 있으므로 API가 더욱 직관적이고 사용하기 쉬워집니다.
2.  캐싱: URI 경로의 데이터는 프록시와 같은 중간 캐시에 의해 캐싱될 수 있으므로 성능이 향상되고 서버 로드가 감소할 수 있습니다.
3.  책갈피: URI 경로에 데이터를 포함하면 URL에 필요한 모든 데이터가 포함되어 있으므로 사용자가 특정 리소스를 더 쉽게 책갈피에 추가할 수 있습니다.
4.  검색 엔진 최적화: URI 경로에 데이터를 포함하면 URL이 더 설명적이어서 검색 엔진 최적화를 개선할 수 있습니다.
5.  보안: URI 경로에 민감한 데이터를 포함하는 것이 요청 본문이나 쿼리 매개변수에 포함하는 것보다 더 안전할 수 있습니다. URI는 종종 암호화되어 중개자가 변경할 수 없기 때문입니다.

전반적으로 URI 경로에 데이터를 포함하면 API를 보다 사용자 친화적이고 성능이 우수하며 안전하게 만들 수 있습니다.