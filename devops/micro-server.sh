#!/usr/bin/env bash

BRANCH_NAME=$1

SERVER_LIST=('passport-account' 'passport-oauth' 'passport-open-platform')

if [[ -z ${BRANCH_NAME} ]]; then
    echo "缺少分支名称参数：$0 BRANCH_NAME"
    exit
fi

echo "处理proto依赖"
for PROTO in ${SERVER_LIST[@]}
do
    PROTO_NAME="${PROTO}-proto"

    echo "proto: ${PROTO_NAME}"

    cd ${PROTO_NAME} && \
    git checkout ${BRANCH_NAME} && \
    git checkout . && \
    git pull && \
    git checkout dev && \
    git checkout . && \
    git merge ${BRANCH_NAME} && \
    git push && \
    cd ../
done

echo "启动服务"
for SERVER_NAME in ${SERVER_LIST[@]}
do
    echo "server: ${SERVER_NAME}"
    cd ${SERVER_NAME} && \
    git checkout ${BRANCH_NAME} && \
    git checkout . && \
    git pull && \
    git checkout dev && \
    git checkout . && \
    git merge ${BRANCH_NAME} ; \
    git push && \
    python ./setup.py && \
    cd ../
done