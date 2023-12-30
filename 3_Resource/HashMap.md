---
title: HashMap
date: 2022-08-18 15:38:00 +0900
publish: false
aliases: 
tags:
  - hash
  - map
  - java
  - data-structure
categories: Data structure
updated: 2023-09-19 22:32:15 +0900
---

[[Map|Map]] 의 구현체 중 하나이다.

HashMap 은 자료구조로 배열([[Array]])를 사용한다. 배열은 '인덱스'를 통해 바로 접근이 가능하다는 장점이 있다. HashMap 은 해싱(Hashing)을 통해 Map 데이터가 저장될 위치의 인덱스를 구한다. 그래서 이름이 HashMap 이다.

key 를 해싱함수(function)에 넣어 인덱스를 산출한 후, 해당 인덱스에 Map 데이터를 저장하는 것이 HashMap 의 기본 원리이다.

![[Pasted image 20230918112614.png]]

해싱은 인덱스를 구하는 것이 목적이다. 그러므로 지켜야될 조건이 있다.

1. hashing 의 결과는 정수여야 한다.
2. hashing 의 결과는 배열의 크기를 넘어서면 안된다.

HashMap 은 key 만 있다면 해싱함수를 통해 바로 해당 인덱스의 위치로 이동할 수 있다. key 를 통해 인덱스를 산출 후, 데이터에 접근하면 시간복잡도가 $O(1)$ 이다.

Map 에서 사용하는 배열은 버킷(bucket)이라 부른다. 버킷 안에 저장된 Map 데이터를 자바에서는 Node 객체로 만들어 관리한다.

```java
public class HashMap<K, V>
        extends AbstractMap<K, V>
        implements Map<K, V>, Cloneable, Serializable {

    // ...
    transient Node<K,V>[] table; // 이 table 이 버킷이다.

    // ...
}
```

```java
static class Node<K,V> implements Map.Entry<K,V> {
    final int hash;
    final K key;
    V value;
    Node<K,V> next;
```

버킷 안에 저장된 데이터는 Node 객체이다. Node 객체는 필드로 hash 값, key, value 그리고 next(다음 노드의 참조)를 가지고 있다.

### 충돌 (collision)

key 만 있으면 해싱함수를 통해 바로 데이터에 접근할 수 있다는 장점이 있지만 이로 인해 생기는 단점이 있다. key 는 사실상 무한하지만 인덱스는 한계가 있다. 인덱스는 배열의 크기보다 작은 정수로 한정되어 있기 때문이다. 그러므로 key 들 사이의 충돌은 불가피하다. 서로 다른 key 들이 같은 인덱스를 부여받는 것이다.

[[Java|Java]]에서는 두 가지 방법으로 충돌을 관리한다.

#### Threshold

첫 번째는 버킷 사이즈를 조절하는 것이다. 버킷의 75% 가 채워지면 충돌 확률은 크게 늘어난다. 그래서 근본적으로 HashMap 은 버킷의 입실률이 75%가 넘으면 버킷의 사이즈를 늘린다.

버킷을 생성할 때, threshold를 지정한다. threshold란 버킷의 크기를 resize() 할 때의 임계점을 의미한다. 만약 threshold 가 12이면 버킷 안에 저장된 데이터가 12개를 넘어가면 버킷의 사이즈를 **2배** 더 늘린다.

HashMap 이 처음 생성되면 버킷사이즈는 16이고 16의 75%가 임계점이므로 threshold 는 12가 된다. 만약 버킷에 데이터가 저장되어 그 수가 12를 넘어가면 버킷의 사이즈는 원래 사이즈의 2배인 32가 된다. 그럼 threshold 도 2배 커진 24가 된다.

이렇듯 Java 는 HashMap 의 버킷 입실률이 75%가 넘지 않도록 버킷의 사이즈를 조절하면서 충돌이 일어나지 않도록 관리한다.

#### Linked List + Red-Black Tree

버킷의 사이즈를 조절한다고 충돌이 안 일어나는 것은 아니다. 그래서 충돌 시 어떻게 대응하는지 아는 것이 중요하다. Java 에서는 충돌의 횟수에 따라 충돌한 데이터들의 저장방식을 달리 한다.

충돌 초기에는 [[Linked List]] 방식으로 충돌에 대응한다. 이를 separate chaining 방식이라 부른다.

![[Pasted image 20230918143157.png]]

버킷이 가리키는 Node 객체는 next 필드를 갖고 있다. 어떤 Node 객체와 인덱스가 같아 충돌이 일어나면, 이미 자리잡고 있던 Node 객체의 next 필드 안에 새로 들어온 Node 객체의 참조 주소를 저장한다.

```java
for (int binCount = 0; ; ++binCount) {
    if ((e = p.next) == null) {
        p.next = newNode(hash, key, value, null);
        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
            treeifyBin(tab, hash);
        break;
    }
    if (e.hash == hash &&
        ((k = e.key) == key || (key != null && key.equals(k))))
        break;
    p = e;
}
```

버킷에 객체를 저장하는 메서드인 `putVal` 메서드를 살펴보면 binCount 가 있다. binCount 는 충돌이 일어나는 횟수를 체크한다. 충돌 횟수가 (TREEIFY_THRESHOLD - 1) 를 넘으면 [[Linked List]] 방식의 데이터 저장방식은 효율이 떨어진다.

![[Pasted image 20230918143615.png]]

![[Pasted image 20230918143806.png]]

만약 어떤 Node 객체가 n번 충돌되어 n번째 Node 의 next 에 저장된다면 해당 Node 를 탐색하는데 시간복잡도는 $O(n)$ 이 된다. 충돌이 많아지면 많아질수록 그 효율이 떨어지는 것이다. 그래서 일정 충돌 수가 넘어가면 데이터 저장방식이 바뀌는데 그것이 [[Red-Black Tree]] 이다.

Linked List 방식은 Node 객체여야 하지만 충돌이 심해져 [[Red-Black Tree]]로 바뀌면 단순 Node 객체로는 [[Red-Black Tree]]를 구현할 수 없다. 그래서 Node 객체를 TreeNode 객체로 바꿔야 한다. TreeNode 는 Node 객체에 몇가지 기능을 추가한 것이다.

![[Pasted image 20230918143940.png]]

![[Pasted image 20230918144231.png]]

`treeifyBin` 메서드는 Node 객체를 TreeNode 객체로 바꿔주는 메서드이다.

`replacementTreeNode` 메서드에 의해 Node 객체가 TreeNode 객체로 바뀐다. do-while 반복문의 첫 반복일 때, 실인수로 들어간 e는 충돌이 발생한 인덱스에 저장된 첫번째 Node 객체이다. do-while 반복문을 돌면서 인덱스에 [[Linked List]] 방식으로 저장된 Node 들을 하나씩 TreeNode 로 바꿔준다.

이렇게 트리화가 완료되면 데이터를 탐색하는데 걸리는 시간복잡도는 $O(logN)$ 이 된다. [[Linked List]] 의 $O(N)$ 보다 효율적인 탐색이 가능해지는 것이다.

#### 트리화의 Threshold 는 왜 6 과 8일까?

맵에 삽입과 삭제가 대부분 1개 안팎에서 발생한다고 가정하기 때문이다. 만약 7과 8이라면, 충돌된 객체가 하나 삭제되면 Linked List 로 변경해야한다. 다시 하나가 추가되면 트리화를 해야한다. 이 자료구조의 변경이 오버헤드가 되는 것을 막기 위해서 버퍼의 역할로 2개의 차이를 둔 것이다.

## Conclusion

1. HashMap 은 해싱함수를 통해 저장될 배열의 위치인 인덱스를 얻는다.
2. HashMap 은 인덱스를 통한 접근으로 시간복잡도 $O(1)$ 의 빠른 성능을 보여준다.
3. key 는 무한하지만 인덱스는 한정되어 있어 충돌은 불가피하다.
4. 충돌을 줄이기 위해 HashMap 은 버킷의 사이즈를 조절한다.
5. 충돌이 적을 때는 Linked List 방식으로 객체들을 관리하다가, 임계점을 넘으면 Red-Black Tree 방식으로 객체들을 저장한다.
6. 저장시 순서가 일정하지 않다.

## Reference

 - https://lordofkangs.tistory.com/78

## Links

- [[Java Collection Framework|JCF]]
- [[Data structure]]
- [[Hash]]