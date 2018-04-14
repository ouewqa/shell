#!/usr/bin/env bash

SIGN_STRING='Scheduler/yii task/index'
WORKER_COUNT=`ps -ef | grep -v 'grep' | grep "${SIGN_STRING}" | wc -l`

if [ ${WORKER_COUNT} -gt 0 ]; then
    echo '已存在任务实例，程序退出。'  >> ~/developments/oschina/Scheduler/console/runtime/logs/crontab.log
    exit 0
else
    echo '启动计划任务……' >> ~/developments/oschina/Scheduler/console/runtime/logs/crontab.log
fi

sudo php ~/developments/oschina/Scheduler/yii task/index >> ~/developments/oschina/Scheduler/console/runtime/logs/crontab.log


