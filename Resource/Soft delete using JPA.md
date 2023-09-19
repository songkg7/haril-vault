---
title: Soft delete using JPA
date: 2023-07-19 09:07:00 +0900
aliases: null
tags:
  - jpa
  - soft-delete
categories: null
updated: 2023-08-26 13:39:44 +0900
---

## JPA 에서 Soft delete 를 구현하려면?

`@SQLDelete` 의 사용

Soft delete는 데이터를 실제로 삭제하지 않고, 삭제된 것으로 표시하는 것을 말합니다. JPA에서 Soft delete를 구현하기 위해서는 Delete 어노테이션을 사용할 수 있습니다.

`@SQLDelete` 어노테이션은 엔티티의 삭제 쿼리를 커스터마이즈하기 위해 사용됩니다. 이 어노테이션을 사용하여 DELETE 쿼리를 오버라이드하고, 삭제 대신 데이터 상태를 변경하는 쿼리를 작성할 수 있습니다.

예를 들어, User 엔티티에서 Soft delete를 구현하려면 다음과 같이 할 수 있습니다.

```java
@Entity
@Table(name = "users")
@SQLDelete(sql = "UPDATE users SET deleted = true WHERE id = ?")
public class User {
    //...
}
```

위의 예제에서는 users 테이블의 `deleted` 컬럼을 사용하여 삭제 여부를 표시하고 있습니다. `@SQLDelete` 어노테이션을 사용하여 DELETE 쿼리가 실행될 때, 해당 엔티티의 `id`에 해당하는 레코드의 `deleted` 값을 true로 변경합니다.

또한, Soft delete된 엔티티들을 조회할 때는 기본적으로 삭제되지 않은 엔티티만 반환해야 합니다. 이를 위해 JPA에서는 @Where 어노테이션을 사용할 수 있습니다.

```java
@Entity
@Table(name = "users")
@SQLDelete(sql = "UPDATE users SET deleted = true WHERE id = ?")
@Where(clause = "deleted = false")
public class User {
    //...
}
```

위의 예제에서는  어노테이션을 사용하여 컬럼이 false인 엔티티만 조회되도록 설정하였습니다.

Soft delete를 구현하기 위해서는 삭제된 엔티티를 복구하는 기능도 필요할 수 있습니다. 이를 위해 복구 쿼리를 작성할 수도 있지만, JPA에서는 Where 어노테이션과 함께`deleted` 컬럼을 사용하여 삭제되지 않은 엔티티만 조회하는 방법을 추천합니다.

```java
@Entity
@Table(name = "users")
@SQLDelete(sql = "UPDATE users SET deleted = true WHERE id = ?")
@Where(clause = "deleted = false")
public class User {
    //...
}

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findAllByDeletedFalse();
}
```

위의 예제에서는 UserRepository 인터페이스에서 ByDeletedFalse() 메소드를 정의하여 삭제되지 않은 모든 엔티티를 조회할 수 있습니다.

```java
@Entity
@Table(name = "users")
@EntityListeners(UserSoftDeleteListener.class)
public class User {
    //...
}

@Component
public class UserSoftDeleteListener {

    @PreRemove
    public void preRemove(User user) {
        user.setDeleted(true);
        // perform any additional logic before soft deleting the entity
    }
}

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findAllByDeletedTrue();
}
```

위의 예제에서는 DeleteListener 클래스에서 `@PreRemove` 어노테이션을 사용하여 삭제 전에 추가 로직을 실행하고, `User` 엔티티의 `deleted` 값을 true로 설정합니다. UserRepository 인터페이스에서는 `findAllByDeletedTrue()` 메소드를 정의하여 삭제된 모든 엔티티를 조회할 수 있습니다.

## Links

[[Java Persistence API|JPA]]
