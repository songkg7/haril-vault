---
title: "Consistent Hashing"
date: 2023-04-20 13:41:00 +0900
aliases: 
tags: [hash, algorithm]
categories: 
updated: 2023-05-26 17:12:08 +0900
banner: "![[consistent hash.png]]"
---

안정 해시를 설명하기 전에 먼저 해시([[Hash]])에 대해서 간단하게 되집어보고 넘어가 봅니다.

## What is Hash?

임의 길이의 데이터 문자열을 입력으로 받아서 고정 크기의 출력, 일반적으로는 숫자와 문자열로 이루어진 해시 값 또는 해시 코드를 생성하는 수학적 함수이다.

같은 문자열 입력은 항상 같은 해시 코드를 반환한다.

## So, what is Consistent Hashing?

안정 해시(Consistent Hashing)이란 분산되어 있는 서버 혹은 서비스에 데이터를 균등하게 나누기 위한 기술이다.

그렇다면 안정 해시가 아니라면 서버 혹은 서비스에 데이터를 균등하게 나누기 어렵다는 의미일까? 그것은 아니다. 하지만 그렇다면 안정 해시가 필요한 이유는 무엇인가?

안정 해시는 수평적 확장을 용이하게 하는 것에 초점이 맞춰져 있다.

### 기존 해시 라우팅 방식

```java
hash(key) % n // n 은 node 의 수
```

![[Pasted image 20230523203910.png]]

이 방식은 단순하지만 매우 효율적으로 트래픽을 분산해준다.

하지만 수평적 확장에 매우 취약한 단점이 있다. node 목록이 변화하면 트래픽이 재분배되면서 기존 노드가 아닌 새로운 노드로 라우팅될 확률이 크게 증가한다.

만약 특정 노드에 캐시를 해두는 방식으로 트래픽을 관리하고 있다면, 모종의 이유에 의해 노드가 그룹에서 이탈했을 경우 대량의 캐시 미스를 일으켜 서비스의 장애를 야기할 수 있다.

![[Pasted image 20230523204056.png]]

## 안정 해시의 문제점

### 키를 균등하게 분포시키기 어렵다

![[Pasted image 20230523204228.png]]

해시 함수의 결과를 예측하는 것은 어려운 일이다. 그러므로 이 결과에 의해 링 위 포지션이 정해지는 Consistent hash 는 키가 균등하게 링 위에 분포할 것이라고 보장할 수 없다.

### HotSpot

![[Pasted image 20230523204258.png]]

_B 노드가 과한 해시공간을 할당받게 되어 다음 노드인 D 노드에 트래픽이 쏠릴 수 있다._

노드가 제거되면 HotSpot 문제가 생길 수 있다

노드가 불균형하게 배치된 결과, 특정 노드에 트래픽이 쏠리는 Hotspot 문제가 생길 수 있다.

## 해결방법

가상 노드(Virtual node)를 두어 해결한다.

![[Pasted image 20230523204810.png]]

가상 노드를 늘리면 key 가 저장될 해시 공간에 가상노드가 존재하기 때문에 해시 충돌이 잦아질 수 있다. 때문에 적절한 값을 선택해야 한다.

## 구현

안정 해시는 적절한 해시 알고리즘을 선택하는 것이 매우 중요하다. 일반적으로 널리 사용되는 해시 알고리즘은 MD5 와 SHA-256 이 있다.

- MD5: 속도가 보안보다 중요한 어플리케이션. SHA-256 에 비해 해시 공간은 작다. 2^128
- SHA-256: 더 긴 해시 크기와 더 강력한 암호화 속성. 속드는 MD5 에 비해 느리다. 2^256, 1.15792 x 10^77 정도의 매우 큰 해시 공간을 갖기 때문에 충돌이 거의 발생하지 않는다.

라우팅에서는 보안보다 속도가 중요하고 해시 충돌 걱정이 덜하기 때문에 MD5 로도 충분하다.

### Hash Ring

```java
public T routeNode(String businessKey) {
    if (ring.isEmpty()) {
        return null;
    }
    Long hashOfBusinessKey = this.hashAlgorithm.hash(businessKey);
    SortedMap<Long, VirtualNode<T>> biggerTailMap = ring.tailMap(hashOfBusinessKey);
    Long nodeHash;
    if (biggerTailMap.isEmpty()) {
        nodeHash = ring.firstKey();
    } else {
        nodeHash = biggerTailMap.firstKey();
    }
    VirtualNode<T> virtualNode = ring.get(nodeHash);
    return virtualNode.getPhysicalNode();
}
```

ring 은 `TreeMap` 을 사용하여 구현했다. `tailMap(key)` 메서드를 통해서 특정 해시값보다 큰 값들을 찾아올 수 있고, 없다면 `firstKey` 로 연결하여 링을 구현한다.

일반 라우팅 방법에 비해 안정해시 라우팅은 얼마나 효과적일까?

간단한 테스트 코드를 통해서 수치화했고, 이를 그래프로 그려봤다.

이미지 추가

## 질문

### 해시 충돌이 일어난다면?

안정 해시에서 해시 충돌이 일어나는 경우는 이미 해당 해시값에 node 가 자리하고 있는 경우이다. routing 을 위한 해시값을 저장하지는 않는다. 그러므로 해시 충돌이 일어날 가능성은 매우 낮으며 났다고 해서 문제되지 않는다. 충돌한 node 바로 다음 node 를 향해 라우팅 될 것이기 때문이다.

안정 해시로 구현된 해시 공간은 일종의 레이싱 트랙

> [!INFO]
> 전체 코드는 [Github](https://github.com/songkg7/consistent-hashing-sample)에서 확인하실 수 있습니다.

## Reference

- [Java HashMap 은 어떻게 동작하는가](https://d2.naver.com/helloworld/831311)
- [안정 해시 설계](https://donghyeon.dev/%EC%9D%B8%ED%94%84%EB%9D%BC/2022/03/20/%EC%95%88%EC%A0%95-%ED%95%B4%EC%8B%9C-%EC%84%A4%EA%B3%84/)
- https://github.com/Lonor/websocket-cluster