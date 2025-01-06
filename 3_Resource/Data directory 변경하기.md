---
title: Data directory 변경하기
date: 2022-08-22T20:46:00
fc-calendar: Gregorian Calendar
fc-date: 2022-08-22
aliases: 
tags:
  - teamcity
  - directory
  - configuration
categories: TeamCity
updated: 2025-01-07T00:35
---

[[TeamCity]]의 기본 directory path 는 `/var/lib/teamcity/.BuildServer` 이다. 하지만 artifact 를 포함한 파일들은 용량이 큰 경우가 있기 때문에 [[AWS EBS]] 같은 외부 파일 Storage 를 활용하면 더욱 효과적으로 로그 및 파일 기록이 가능하다.

### 기존 데이터 복사

`-p` 옵션을 사용하여 권한 정보를 포함하여 복사한다.

```bash
cp -rp /var/lib/teamcity/.BuildServer /data/teamcity/.BuildServer
```

### 초기 설정 수정

```bash
vi /etc/init.d/teamcity
```

```bash
#!/bin/bash
### BEGIN INIT INFO
# Provides:          teamcity
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: TeamCity
# Description:       TeamCity
### END INIT INFO

TEAMCITY_USER=teamcity
TEAMCITY_DIR=/var/lib/teamcity
TEAMCITY_PATH=$TEAMCITY_DIR/bin/runAll.sh
TEAMCITY_DATA_DIR=/data/teamcity/.BuildServer # DATA_DIR 을 변경할 경로로 수정

case $1 in

  start)
    echo "Starting Team City"
    su - $TEAMCITY_USER -c "TEAMCITY_DATA_PATH=$TEAMCITY_DATA_DIR $TEAMCITY_PATH start"
    ;;
  stop)
    echo "Stopping Team City"
    su - $TEAMCITY_USER -c "TEAMCITY_DATA_PATH=$TEAMCITY_DATA_DIR $TEAMCITY_PATH stop"
    ;;
  restart)
    echo "Restarting Team City"
    su - $TEAMCITY_USER -c "TEAMCITY_DATA_PATH=$TEAMCITY_DATA_DIR $TEAMCITY_PATH stop"
    su - $TEAMCITY_USER -c "TEAMCITY_DATA_PATH=$TEAMCITY_DATA_DIR $TEAMCITY_PATH start"
    ;;
  *)
    echo "Usage: /etc/init.d/teamcity {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
```

### Reload 후 TeamCity 재시작

```bash
systemctl daemon-reload
systemctl start teamcity
```

Loading 후 admin page 에서 확인해보면 data directory 가 변경된 것을 확인할 수 있다.

![[data-directory.png]]
