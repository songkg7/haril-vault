---
title: "트랜잭션 격리 레벨의 동작 원리"
date: 2023-07-14 23:29:00 +0900
aliases: 
tags: 
categories: 
updated: 2023-07-15 01:29:23 +0900
---

## `@Transational` 로 설정하는 격리레벨은 실제로 어떻게 동작할까

[[Spring framework]] 의 트랜잭션 격리 레벨은 총 5가지가 있다.

```java
package org.springframework.transaction.annotation;

import org.springframework.transaction.TransactionDefinition;

public enum Isolation {
	DEFAULT(TransactionDefinition.ISOLATION_DEFAULT),
	READ_UNCOMMITTED(TransactionDefinition.ISOLATION_READ_UNCOMMITTED),
	READ_COMMITTED(TransactionDefinition.ISOLATION_READ_COMMITTED),
	REPEATABLE_READ(TransactionDefinition.ISOLATION_REPEATABLE_READ),
	SERIALIZABLE(TransactionDefinition.ISOLATION_SERIALIZABLE);

	private final int value;


	Isolation(int value) {
		this.value = value;
	}

	public int value() {
		return this.value;
	}

}
```

```java
// PlatformTransactionManager
private TransactionStatus startTransaction(TransactionDefinition definition, Object transaction,
        boolean debugEnabled, @Nullable SuspendedResourcesHolder suspendedResources) {

    boolean newSynchronization = (getTransactionSynchronization() != SYNCHRONIZATION_NEVER);
    DefaultTransactionStatus status = newTransactionStatus(
            definition, transaction, true, newSynchronization, debugEnabled, suspendedResources);
    doBegin(transaction, definition); // 이 과정에서 connection 을 획득한다.
    prepareSynchronization(status, definition);
    return status;
}
```

`Connection` 객체를 살펴보면 `setTransactionIsolation` 이라는 메서드로 level 을 설정하도록 되어 있다. `Connection` 객체를 가져온 이후 Transaction Isolation Level 을 변경할 수 있다.

```java
// Connection
void setTransactionIsolation(int level) throws SQLException;
```

해당 인터페이스의 JDBC 구현체인 JDBCConnection 을 살펴보면 상세 구현을 확인할 수 있다.

```java
// JDBCConnection
public synchronized void setTransactionIsolation(
        int level) throws SQLException {

    checkClosed();

    switch (level) {

        case TRANSACTION_READ_UNCOMMITTED :
        case TRANSACTION_READ_COMMITTED :
        case TRANSACTION_REPEATABLE_READ :
        case TRANSACTION_SERIALIZABLE :
            break;
        default :
            throw JDBCUtil.invalidArgument();
    }

    try {
        sessionProxy.setIsolationDefault(level); // level 설정
    } catch (HsqlException e) {
        throw JDBCUtil.sqlException(e);
    }
}
```

int 값인 level 에 따라서 격리레벨이 sessionProxy 라는 객체에 설정되는 것을 볼 수 있다.

DB 에 따라 지원되지 않는 격리레벨이 있으므로, 격리레벨을 설정하고나면 DB 변경 요구사항이 발생할 경우 주의해야 한다.