#!/usr/bin/env bash

BRANCH_NAME=$1

SERVER_LIST=(
'passport-account' 'passport-oauth' 'passport-open-platform'
'passport-account-proto' 'passport-oauth-proto' 'passport-open-platform-proto'
)

if [[ -z ${BRANCH_NAME} ]]; then
    echo "缺少分支名称参数：$0 BRANCH_NAME"
    exit
fi

for SERVER_NAME in ${SERVER_LIST[@]}
do
    echo "创建分支: ${SERVER_NAME}:${BRANCH_NAME}"

    cd ${SERVER_NAME} && \
    git checkout master && \
    git pull; \
    git checkout -b ${BRANCH_NAME} && \
    git push origin ${BRANCH_NAME}:${BRANCH_NAME} && \
    cd ../
done